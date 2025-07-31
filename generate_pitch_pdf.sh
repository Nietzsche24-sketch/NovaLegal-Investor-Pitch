#!/bin/bash

HTML_FILE="nova_pitch_landing.html"
PDF_FILE="NovaLegal_Comparison.pdf"

# Check dependencies
if ! command -v node &> /dev/null; then
    echo "❌ Node.js is not installed. Install it first."
    exit 1
fi

if ! node -e "require('playwright')" &> /dev/null; then
    echo "❌ Playwright not found. Run: npm install playwright"
    exit 1
fi

if [ ! -f "$HTML_FILE" ]; then
    echo "❌ Error: $HTML_FILE not found in this directory."
    exit 1
fi

# Define inline Node.js script
NODE_SCRIPT=$(cat <<'EOF'
const { chromium } = require('playwright');

(async () => {
    const browser = await chromium.launch();
    const page = await browser.newPage();
    await page.goto(`file://${process.cwd()}/nova_pitch_landing.html`, { waitUntil: 'networkidle' });
    await page.pdf({ path: 'NovaLegal_Comparison.pdf', format: 'A4', printBackground: true });
    await browser.close();
})();
EOF
)

# Save + run the script
echo "$NODE_SCRIPT" > _render_temp.js
node _render_temp.js
rm _render_temp.js

# Verify
if [ -f "$PDF_FILE" ]; then
    echo "✅ PDF successfully created: $PDF_FILE"
else
    echo "❌ PDF generation failed."
    exit 1
fi
