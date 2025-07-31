#!/bin/bash

# Paths
OUTPUT_HTML="NovaLegal_Investor_Pitch_Deck_FULL.html"
OUTPUT_PDF="NovaLegal_Investor_Pitch_Deck_FULL.pdf"
INPUT_DIR="./NovaLegal_Pitch_Package"

# Start the HTML file
cat > "$OUTPUT_HTML" <<EOF
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>NovaLegal Investor Pitch Deck</title>
  <style>
    body { font-family: Helvetica, sans-serif; margin: 2rem; line-height: 1.6; }
    h1, h2 { color: #003366; }
    pre { background: #f4f4f4; padding: 1em; overflow-x: auto; }
    hr { margin: 2em 0; }
  </style>
</head>
<body>
  <h1>NovaLegal Investor Pitch Deck</h1>
  <p><em>Auto-generated: $(date)</em></p>
  <hr>
EOF

# Append each text file
for f in "$INPUT_DIR"/*.txt; do
  echo "  <h2>$(basename "$f")</h2>" >> "$OUTPUT_HTML"
  echo "  <pre>" >> "$OUTPUT_HTML"
  cat "$f" >> "$OUTPUT_HTML"
  echo "  </pre><hr>" >> "$OUTPUT_HTML"
done

# Embed PDF summary link
echo "<h2>PDF Comparison</h2>" >> "$OUTPUT_HTML"
echo "<p>See <a href=\"NovaLegal_Comparison.pdf\">NovaLegal_Comparison.pdf</a> for the Spellbook breakdown.</p>" >> "$OUTPUT_HTML"

# End HTML
echo "</body></html>" >> "$OUTPUT_HTML"

# Convert HTML to PDF (requires wkhtmltopdf)
if command -v weasyprint &> /dev/null; then
  weasyprint "$OUTPUT_HTML" "$OUTPUT_PDF"
  echo "✅ PDF generated with WeasyPrint: $OUTPUT_PDF"
else
  echo "⚠️ Install wkhtmltopdf to enable PDF output:"
  echo "  brew install wkhtmltopdf"
fi

echo "✅ Done. Final deck: $OUTPUT_HTML"
