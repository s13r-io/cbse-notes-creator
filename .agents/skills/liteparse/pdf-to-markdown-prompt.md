# PDF-to-Markdown Restructuring Prompt

Use this prompt in Step 2 of the PDF-to-markdown pipeline (after LiteParse text extraction).

---

## Prompt

````text
Convert the following extracted PDF text into clean, well-structured Markdown. The source is an NCERT textbook chapter.

Requirements:
1. Preserve the original meaning exactly. Do not add, remove, reinterpret, or invent content.
2. Remove PDF artifacts: standalone page numbers, running headers/footers, excessive blank lines, broken spacing, and layout noise.
3. Reconstruct the document into proper Markdown using:
   - `#` for the chapter title
   - `##` for main numbered sections (e.g., "1", "2", "3")
   - `###` for subsections (e.g., "1.1", "1.2")
   - `####` for sub-subsections if present
   - bullet lists where appropriate
   - numbered lists for sequential steps or items
   - Markdown tables for tabular content
   - fenced code blocks for solved numerical problems and step-by-step calculations
4. Preserve all key terms in **bold** exactly as they appear emphasized in the original.
5. Preserve all definitions, formulas, numerical values, dates, and proper nouns exactly.
6. For side boxes and special sections commonly found in NCERT books, use blockquote formatting:
   - `> **Activity**` followed by the activity content
   - `> **Do You Know?**` followed by the content
   - `> **Let's Investigate / Let's Do**` followed by the content
   - `> **Important / Note**` followed by the content
   - `> **Source [A/B/C...]:** [attribution line if present]` followed by the excerpt text on subsequent blockquote lines
   - `> **New Words:**` followed by each term and its definition (preserve exactly as written)
7. For solved examples (common in Math and Science):
   ```
   **Example 1:** [Title if any]

   **Solution:**
   [Steps in a fenced code block or numbered list]
   ```
8. Convert visually aligned tables into proper Markdown tables.
9. For figure/diagram references, preserve them as:
   ```
   **Figure 1:** [Caption text]
   ```
   If the extracted text includes diagram labels or descriptions, include them in a blockquote under the figure reference.
10. For glossary terms at the end of a chapter, format as a definition list or table.
11. Preserve the chapter-end summary section if present, keeping its heading as `## Summary` or `## Key Points`.

Important constraints:
- Do not summarize.
- Do not shorten.
- Do not rewrite for style.
- Do not normalize terminology beyond formatting.
- If text is ambiguous, preserve it as-is rather than guessing.
- Do not explain what you changed.
- Output only the final Markdown.

Here is the extracted text:

[PASTE TEXT HERE]
````

---

## Notes

- For **Hindi medium** NCERT PDFs, the same prompt works — the agent will detect Hindi text and produce Hindi markdown.
- For **Mathematics** chapters, pay extra attention to preserving formulas (use LaTeX `$$` notation if the extracted text contains mathematical notation).
- For **diagram-heavy** chapters (Biology, Geography), the prompt preserves figure captions and labels but cannot reconstruct images — those would need separate screenshots via `lit screenshot`.
