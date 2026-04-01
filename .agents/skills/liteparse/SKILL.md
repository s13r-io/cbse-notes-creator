---
name: liteparse
description: Use this skill when the user asks to parse, perform multi-format document conversion or spatially extract text from an unstructured file (PDF, DOCX, PPTX, XLSX, images, etc.) locally without cloud dependencies.
compatibility: Requires Node 18+ and `@llamaindex/liteparse` installed globally via npm (`npm i -g @llamaindex/liteparse`)
license: MIT
metadata:
  author: LlamaIndex
  version: "0.1.0"
---

# LiteParse Skill

Parse unstructured documents (PDF, DOCX, PPTX, XLSX, images, and more) locally with LiteParse: fast, lightweight, no cloud dependencies or LLM required.

## Initial Setup

When this skill is invoked, respond with:

```
I'm ready to use LiteParse to parse files locally. Before we begin, please confirm that:

- `@llamaindex/liteparse` is installed globally (`npm i -g @llamaindex/liteparse`)
- The `lit` CLI command is available in your terminal

If both are set, please provide:

1. One or more files to parse (PDF, DOCX, PPTX, XLSX, images, etc.)
2. Any specific options: output format (json/text), page ranges, OCR preferences, DPI, etc.
3. What you'd like to do with the parsed content.

I will produce the appropriate `lit` CLI command or TypeScript script, and once approved, report the results.
```

Then wait for the user's input.

---

## Step 1 — Install LiteParse (if needed)

If `liteparse` is not yet installed, install it globally:

```bash
npm i -g @llamaindex/liteparse
```

Verify installation:

```bash
lit --version
```

For Office document support (DOCX, PPTX, XLSX), LibreOffice is required:

```bash
# macOS
brew install --cask libreoffice

# Ubuntu/Debian
apt-get install libreoffice
```

For image parsing, ImageMagick is required:
```bash
# macOS
brew install imagemagick

# Ubuntu/Debian
apt-get install imagemagick
```

---

## Step 2 — Produce the CLI Command or Script

### Parse a Single File

```bash
# Basic text extraction
lit parse document.pdf

# JSON output saved to a file
lit parse document.pdf --format json -o output.json

# Specific page range
lit parse document.pdf --target-pages "1-5,10,15-20"

# Disable OCR (faster, text-only PDFs)
lit parse document.pdf --no-ocr

# Use an external HTTP OCR server for higher accuracy
lit parse document.pdf --ocr-server-url http://localhost:8828/ocr

# Higher DPI for better quality
lit parse document.pdf --dpi 300
```

### Batch Parse a Directory

```bash
lit batch-parse ./input-directory ./output-directory

# Only process PDFs, recursively
lit batch-parse ./input ./output --extension .pdf --recursive
```

### Generate Page Screenshots

Screenshots are useful for LLM agents that need to see visual layout.

```bash
# All pages
lit screenshot document.pdf -o ./screenshots

# Specific pages
lit screenshot document.pdf --pages "1,3,5" -o ./screenshots

# High-DPI PNG
lit screenshot document.pdf --dpi 300 --format png -o ./screenshots

# Page range
lit screenshot document.pdf --pages "1-10" -o ./screenshots
```

---

## Step 3 — Key Options Reference

### OCR Options

| Option | Description |
|--------|-------------|
| (default) | Tesseract.js — zero setup, built-in |
| `--ocr-language fra` | Set OCR language (ISO code) |
| `--ocr-server-url <url>` | Use external HTTP OCR server (EasyOCR, PaddleOCR, custom) |
| `--no-ocr` | Disable OCR entirely |

### Output Options

| Option | Description |
|--------|-------------|
| `--format json` | Structured JSON with bounding boxes |
| `--format text` | Plain text (default) |
| `-o <file>` | Save output to file |

### Performance / Quality Options

| Option | Description |
|--------|-------------|
| `--dpi <n>` | Rendering DPI (default: 150; use 300 for high quality) |
| `--max-pages <n>` | Limit pages parsed |
| `--target-pages <pages>` | Parse specific pages (e.g. `"1-5,10"`) |
| `--no-precise-bbox` | Disable precise bounding boxes (faster) |
| `--skip-diagonal-text` | Ignore rotated/diagonal text |
| `--preserve-small-text` | Keep very small text that would otherwise be dropped |

---

## Step 4 — Using a Config File

This project has a `liteparse.config.json` at the repository root with optimized defaults for NCERT PDF extraction (text output, 300 DPI, OCR enabled, small text preserved). Use it with:

```bash
lit parse document.pdf --config liteparse.config.json
```

To override a specific setting, pass it as a CLI flag after `--config`:

```bash
# Hindi-medium PDF
lit parse document.pdf --config liteparse.config.json --ocr-language hin

# Disable OCR (faster for text-embedded PDFs)
lit parse document.pdf --config liteparse.config.json --no-ocr
```

---

## Step 5 — HTTP OCR Server API (Advanced)

If the user wants to plug in a custom OCR backend, the server must implement:

- **Endpoint**: `POST /ocr`
- **Accepts**: `file` (multipart) and `language` (string) parameters
- **Returns**:
```json
{
  "results": [
    { "text": "Hello", "bbox": [x1, y1, x2, y2], "confidence": 0.98 }
  ]
}
```

Ready-to-use wrappers exist for EasyOCR and PaddleOCR in the LiteParse repo.

---

## Supported Input Formats

| Category | Formats |
|----------|---------|
| PDF | `.pdf` |
| Word | `.doc`, `.docx`, `.docm`, `.odt`, `.rtf` |
| PowerPoint | `.ppt`, `.pptx`, `.pptm`, `.odp` |
| Spreadsheets | `.xls`, `.xlsx`, `.xlsm`, `.ods`, `.csv`, `.tsv` |
| Images | `.jpg`, `.jpeg`, `.png`, `.gif`, `.bmp`, `.tiff`, `.webp`, `.svg` |

Office documents require LibreOffice; images require ImageMagick. LiteParse auto-converts these formats to PDF before parsing.

---

## PDF-to-Markdown Pipeline

This project uses a two-step pipeline to convert PDFs into clean Markdown. All intermediate and final output files are saved in the **same directory as the source PDF**.

### Step 1: Extract text from PDF

Derive the output path from the source PDF filename, placed in the same directory:
```bash
lit parse <file.pdf> --config liteparse.config.json -o <same-dir>/<basename>.txt
```

Example: `evals/samples/samplechapter-history.pdf` → `evals/samples/samplechapter-history.txt`

For Hindi-medium PDFs, override the OCR language:
```bash
lit parse <file.pdf> --config liteparse.config.json --ocr-language hin -o <same-dir>/<basename>.txt
```

> **Note:** If the extraction fails with a Tesseract/OCR error, retry with `--no-ocr`. Most NCERT PDFs have embedded text and do not require OCR:
> ```bash
> lit parse <file.pdf> --config liteparse.config.json --no-ocr -o <same-dir>/<basename>.txt
> ```

### Step 2: Restructure text into Markdown

Read the restructuring prompt from `pdf-to-markdown-prompt.md` (co-located with this skill file), then feed the extracted text to the LLM using that prompt. The prompt is tailored for NCERT textbook content (side boxes, solved examples, tables, figure captions, summaries).

Save the final Markdown file in the **same directory as the source PDF**, using the source filename with `.md` extension:

Example: `evals/samples/samplechapter-history.pdf` → `evals/samples/samplechapter-history.md`

The LLM will produce clean, well-structured Markdown preserving all content exactly.

### Step 3: Clean up intermediate file

After the final Markdown file has been saved, delete the intermediate `.txt` file:

```bash
rm <same-dir>/<basename>.txt
```

### Batch: Convert all PDFs in a directory

To convert multiple PDFs at once, loop over them:

```bash
for pdf in <directory>/*.pdf; do
  base=$(basename "$pdf" .pdf)
  dir=$(dirname "$pdf")
  lit parse "$pdf" --config liteparse.config.json --no-ocr -o "$dir/$base.txt"
done
```

Then restructure each `.txt` file to `.md` using the prompt from `pdf-to-markdown-prompt.md`, and delete all intermediate `.txt` files afterward.
