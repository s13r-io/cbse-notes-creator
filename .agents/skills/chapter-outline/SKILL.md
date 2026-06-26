---
name: chapter-outline
description: "Generate a structured chapter outline from a markdown chapter file for study-note creation. Use this skill whenever the user uploads a .md chapter file and wants a study outline — even if they just say 'outline this chapter’ or 'summarise this for me'. If a blueprint or syllabus .md file is also provided, use it to improve exam-priority tagging. Supported subjects: Mathematics, Science, History, Geography, Economics, Political Science (Civics), Computer Science, English, Hindi. Always trigger this skill when a chapter .md file is present and the user's goal is summarising or outlining the chapter."
---

# Chapter Outline Generator

The goal is to help a student or note-writer quickly understand:
- what the chapter covers
- which sections matter most
- which terms and diagrams deserve attention
- where to focus effort before writing full notes

Supported subjects: Mathematics, Science, History, Geography, Economics, Political Science (Civics), Computer Science, English, Hindi

---

## Inputs

| File | Required | Format |
|------|----------|--------|
| Chapter file | Yes | `.md` |
| Blueprint file | No | `.md` |
| Syllabus file | No | `.md` |
| Subject | No (inferred) | See list above |

---

## Input handling

### Identifying uploaded files
If multiple files are uploaded at once, identify each by:
1. Filename (e.g., `blueprint_`, `syllabus_`, chapter names)
2. Content signals: blueprints and syllabi typically contain mark weightages, unit lists, or topic grids; chapters contain prose, headings, and definitions

### Hard requirements
- **Chapter file is mandatory.** If it is missing, ask for it once and stop.
- Do not accept non-markdown files. If a file is not `.md`, ask for a markdown version. Do not attempt conversion.

### Soft requirements (blueprint / syllabus)
- If missing, do **not** block. Continue with heuristic priority tagging and note this in the final report.
- If provided but the chapter is not mentioned, use what partial evidence exists and fill the rest with heuristics.
- If both blueprint and syllabus are provided, use whichever gives clearer section-level weightage. You may combine both if helpful.

### Subject inference
If subject is not stated, infer from these signals:
- **Mathematics**: equations, theorems, proofs, number lines, coordinate geometry
- **Science**: organisms, atoms, forces, chemical reactions, life processes, experiments
- **History**: dates, events, movements, colonial terms, nationalist figures
- **Geography**: landforms, climate, rivers, maps, population, resources
- **Economics**: production, GDP, poverty, markets, sectors
- **Political Science**: constitution, rights, government, democracy, institutions
- **Computer Science**: algorithms, code, data structures, hardware/software terms
- **English**: prose/poetry titles, grammar terms, literary devices, essay types
- **Hindi**: prose/poetry titles, व्याकरण, साहित्यिक devices

If inference is ambiguous, ask the user once with a short list of likely candidates.

---

## Fast validation

Before extracting, confirm:
1. The chapter has a recognisable main topic
2. At least 2 section-level units can be identified (from headings or strong structural breaks)
3. Any provided blueprint/syllabus can be searched for chapter or topic weightage

**Fail conditions:**
- Chapter is empty, garbled, or structurally unusable → stop and ask for a valid file
- Chapter is under 500 words → proceed but note in the final report that the outline may be brief

**Long chapters (over ~6,000 words):** Extract all sections completely. If the chapter is extremely long, note in the final report that coverage is comprehensive but review for completeness.

---

## Extraction rules

### 1. Detect chapter title
Use in this order:
1. First H1 heading
2. Obvious title block at the top of the file
3. First major heading (H2)
4. Short title derived from opening content

If derived rather than directly found, flag this in the final report.

### 2. Build the section hierarchy

Extract:
- H2 → sections
- H3 → subsections, nested under their nearest H2

If headings are missing or inconsistent, infer sections from strong structural breaks (thematic shifts, blank-line clusters, bold paragraph openers).

For every section and subsection, capture:

| Field | Description |
|-------|-------------|
| `title` | The heading or inferred title |
| `summary` | One sentence in plain language |
| `keyTerms` | Important terms introduced or relied upon |
| `diagrams` | Figures, tables, image references, named diagrams |

### 3. Identify key terms

Prefer terms that are:
- Bold or italic on first use
- Explicitly defined in the text
- Repeated as technical vocabulary
- Listed in a glossary or summary box
- Subject-critical concepts essential to understanding the chapter

Exclude generic textbook filler (e.g., "important", "note", "example") unless they anchor a specific concept.

**Deduplication:** Each unique term is counted once across the whole chapter, even if it appears in multiple sections. In the JSON output, terms may repeat across sections but `keyTermCount` in metadata reflects unique terms only.

### 4. Identify diagrams

Capture figure labels, table labels, image references, named diagrams, and clearly described visual structures (e.g., "a labelled diagram of the human heart").

If none exist: use `None` in markdown; use `[]` in JSON.

---

## Priority tagging

Assign `[HIGH]`, `[MED]`, or `[LOW]` to **every** section and subsection.

### Method A: Blueprint or syllabus evidence (preferred)

Map weightage to sections using:
1. Exact chapter-title match
2. Close topic-title or keyword match
3. Keyword overlap with section content

Assign:
- `[HIGH]` → highest-weightage sections
- `[MED]` → moderate-weightage or supporting sections
- `[LOW]` → low-weightage, background, or lightly covered sections

If the external file gives only chapter-level weightage (not section-level), distribute priority within the chapter using section relevance and density (see Method B signals below).

Set `priorityMethod` to `blueprint`.

### Method B: Chapter-only heuristics (fallback)

Score each section/subsection using:
- Concept density (definitions, terms, named concepts per paragraph)
- Number of subsections
- Number of key terms
- Number of diagrams or tables
- Subject-specific signals (see below)

**Subject-specific signals:**
- **Mathematics**: formulas, theorems, proofs, worked examples, problem types
- **Science**: processes, mechanisms, experiments, labeled diagrams, cause-effect chains
- **History**: causes, consequences, events, dates, people, movements
- **Geography**: maps, spatial patterns, processes, data, case studies
- **Economics**: models, graphs, applications, case studies, formula-based reasoning
- **Political Science**: institutions, rights, provisions, comparisons, democratic processes
- **Computer Science**: algorithms, syntax, code examples, data structures, procedures
- **English**: themes, characters, literary devices, grammar rules, writing formats
- **Hindi**: themes, characters, literary devices, व्याकरण, writing formats

**Tagging thresholds (applied to combined sections + subsections):**

| Rank | Tag |
|------|-----|
| Top ~20% | `[HIGH]` |
| Next ~50% | `[MED]` |
| Remainder | `[LOW]` |

**Tie-breaking rules:**
- If two items score equally on the boundary, prefer the one appearing earlier in the chapter for the higher tag
- Ensure at least one `[HIGH]` item exists unless the chapter has fewer than 3 sections (in which case a single `[MED]` chapter is acceptable)
- Do not assign all items the same tag

Set `priorityMethod` to `heuristic`.

---

## Chapter description

Write 2–3 sentences answering:
- What this chapter is about
- Why it matters for a Class 9 student

Rules:
- Plain language, accessible to a 14–15-year-old
- Specific to this chapter — no generic textbook phrasing
- Do not start with "This chapter is about..."

---

## Output selection

| Condition | Generate markdown | Generate JSON |
|-----------|-------------------|---------------|
| Default (no special request) | Yes | No |
| User asks for JSON | Yes | Yes |
| User asks for "structured export" or "machine-readable" | Yes | Yes |
| User mentions downstream use (app, script, quiz generator, flashcard tool, pipeline, automation, import) | Yes | Yes |
| Unclear whether downstream use is intended | Yes | No — default to markdown only |

Do not ask a follow-up question about JSON unless the user specifically mentions export, automation, or machine-readable output.

---

## Save location

1. Determine the source filename without extension (e.g., `chapter_3_atoms` from `chapter_3_atoms.md`)
2. Identify the project root folder (git repository root, or topmost workspace directory)
3. Create a folder with the source filename inside the project root (e.g., `chapter_3_atoms/`)
4. Create a subfolder called `outline/` inside it
5. Save both output files inside the `outline/` subfolder

---

## Markdown output format

Save as: `{source_filename}_outline.md`

```markdown
# Chapter {N}: {Chapter Title}

## Chapter Description
{2–3 sentence description}

## Chapter Outline

### 1. {Section Title} [HIGH/MED/LOW]
- **What it covers:** {1-line summary}
- **Key terms:** term1, term2, term3
- **Diagrams:** Figure X.Y – title | None

#### 1.1 {Subsection Title} [HIGH/MED/LOW]
- **What it covers:** {1-line summary}
- **Key terms:** term1, term2
- **Diagrams:** None
```

---

## JSON output format

Only create when output-selection rules require it.

Save as: `{source_filename}_outline.json`

```json
{
  "chapter": {
    "number": null,
    "title": "{Chapter Title}"
  },
  "description": "{2–3 sentence description}",
  "sections": [
    {
      "title": "{Section Title}",
      "priority": "HIGH",
      "summary": "{1-line summary}",
      "keyTerms": ["term1", "term2"],
      "diagrams": ["Figure X.Y – title"],
      "subsections": [
        {
          "title": "{Subsection Title}",
          "priority": "MED",
          "summary": "{1-line summary}",
          "keyTerms": ["term1"],
          "diagrams": []
        }
      ]
    }
  ],
  "metadata": {
    "subject": "{Subject}",
    "sourceFile": "{original filename}",
    "totalSections": 0,
    "totalSubsections": 0,
    "keyTermCount": 0,
    "diagramCount": 0,
    "priorityDistribution": {
      "HIGH": 0,
      "MED": 0,
      "LOW": 0
    },
    "priorityMethod": "blueprint"
  }
}
```

**JSON rules:**
- Use `null` for unknown chapter number
- Include `subsections` key only if subsections exist
- `keyTermCount` = count of **unique** terms across all sections (deduplicated)
- `diagramCount` = total diagram references across all sections
- `priorityDistribution` counts both sections and subsections
- `HIGH + MED + LOW` must equal `totalSections + totalSubsections`

---

## Final user report

After saving, always report the following — keep it concise and structured:

```
📁 Output saved to: {folder path}

Chapter:         {title}
Sections:        {N}
Subsections:     {N}
Key terms:       {N} unique
Diagrams:        {N}
Priority method: {Blueprint-based | Heuristic (no blueprint/syllabus provided)}
Priority split:  HIGH {N} | MED {N} | LOW {N}
JSON generated:  {Yes – {reason} | No}
```

Then list any caveats on separate lines, only if they apply:
- ⚠ Chapter title was derived, not directly found
- ⚠ Blueprint/syllabus not provided — heuristic tagging used
- ⚠ Blueprint/syllabus did not mention this chapter — partial evidence used
- ⚠ Chapter is short (<500 words) — outline may be brief
- ⚠ Subject could not be inferred — assumed {subject}; correct if wrong
- ⚠ Subject not in supported list — closest heuristic used: {subject}

If there are no caveats, omit that section entirely.

---

## Edge handling summary

| Situation | Action |
|-----------|--------|
| Chapter < 500 words | Proceed; note brevity in report |
| Chapter > 6,000 words | Proceed fully; note length in report |
| Blueprint/syllabus missing | Use heuristics; note in report |
| Blueprint/syllabus partial | Use available evidence + heuristics; note in report |
| Subject unsupported | Use closest supported heuristic; note which one |
| Subject ambiguous | Ask user once with short candidate list |
| Title not in headings | Derive from content; flag in report |
| No diagrams in chapter | Use `None` / `[]` — do not invent |
| Non-markdown file uploaded | Ask for `.md` version; do not convert |
