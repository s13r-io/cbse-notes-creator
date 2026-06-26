# Plan: cbse-notes-creator-v2 — Parallel Agent Skill

## Motivation

The v1 skill takes 10-12 minutes to generate study notes because:
- A single LLM agent sequentially generates 7 sections (6K-10K+ words, 22+ questions with answers)
- All reference files (~6K tokens) are loaded upfront before any generation starts
- Every generation call re-processes the full context (~20K tokens)

**v2 approach**: Split work across an orchestrator + 3 parallel sub-agents, each loading only the reference files it needs. Estimated time: ~5-6 minutes.

---

## Folder Structure

```
cbse-notes-creator-v2/
├── PLAN.md                                  # This file
├── SKILL.md                                 # Orchestrator — 3-phase workflow
└── references/
    ├── shared/
    │   └── writing-principles.md            # Writing rules shared by all agents
    ├── sections/
    │   ├── sec1-introduction.md             # Section 1 template + guidelines
    │   ├── sec2-key-terms.md                # Section 2 template + guidelines
    │   ├── sec3-core-content.md             # Section 3: topic types, depth requirements, universal rules
    │   ├── sec4-misconceptions.md           # Section 4 template + guidelines
    │   ├── sec5-connections.md              # Section 5 template + guidelines
    │   ├── sec6-quick-revision.md           # Section 6 template + guidelines
    │   └── sec7-questions.md                # Section 7: question formats, writing guidelines
    ├── exam/
    │   └── exam-patterns.md                 # Exam structure, question types, answer tips
    └── subjects/                            # NOT copied — referenced from v1
        # SKILL.md references:
        # ../cbse-notes-creator/cbse-notes-creator/references/subjects/{subject}.md
```

### Files to Create

| # | File | Source | Approx Size |
|---|------|--------|-------------|
| 1 | `SKILL.md` | New orchestrator design | ~400-500 lines |
| 2 | `references/shared/writing-principles.md` | Extracted from v1 SKILL.md | ~700 words |
| 3 | `references/sections/sec1-introduction.md` | v1 universal-template.md lines 39-72 | ~200 words |
| 4 | `references/sections/sec2-key-terms.md` | v1 universal-template.md lines 75-97 | ~200 words |
| 5 | `references/sections/sec3-core-content.md` | v1 universal-template.md lines 101-197 | ~1,800 words |
| 6 | `references/sections/sec4-misconceptions.md` | v1 universal-template.md lines 200-222 | ~250 words |
| 7 | `references/sections/sec5-connections.md` | v1 universal-template.md lines 225-259 | ~300 words |
| 8 | `references/sections/sec6-quick-revision.md` | v1 universal-template.md lines 262-301 | ~350 words |
| 9 | `references/sections/sec7-questions.md` | v1 universal-template.md lines 305-466 | ~1,300 words |
| 10 | `references/exam/exam-patterns.md` | v1 exam-patterns-general.md (with terminology fix) | ~1,800 words |

### Files Referenced (Not Copied)

Subject files from v1 (read-only):
- `../cbse-notes-creator/cbse-notes-creator/references/subjects/mathematics.md`
- `../cbse-notes-creator/cbse-notes-creator/references/subjects/science-physics.md`
- `../cbse-notes-creator/cbse-notes-creator/references/subjects/science-chemistry.md`
- `../cbse-notes-creator/cbse-notes-creator/references/subjects/science-biology.md`
- `../cbse-notes-creator/cbse-notes-creator/references/subjects/history.md`
- `../cbse-notes-creator/cbse-notes-creator/references/subjects/geography.md`
- `../cbse-notes-creator/cbse-notes-creator/references/subjects/economics.md`
- `../cbse-notes-creator/cbse-notes-creator/references/subjects/political-science.md`
- `../cbse-notes-creator/cbse-notes-creator/references/subjects/computer-science.md`
- `../cbse-notes-creator/cbse-notes-creator/references/subjects/english.md`
- `../cbse-notes-creator/cbse-notes-creator/references/subjects/hindi.md`

No modifications to any v1 files.

---

## Execution Architecture

### Phase 1 — Analyze & Prepare (~30 seconds)

**Agent**: Main Claude Code agent (the skill itself acts as orchestrator)

1. Read source material completely
2. Validate source (stop-and-check: main topic, 3-4 themes, 2-3 key terms)
3. Identify subject (auto-detect or from user input)
4. Load subject file from v1 path: `../cbse-notes-creator/cbse-notes-creator/references/subjects/{subject}.md`
5. Determine structural variant from subject file
6. Read `references/sections/sec3-core-content.md` — only the topic type decision framework
7. Extract 8-12 core concepts from source, classify each by topic type
8. Build coverage checklist (every sub-topic, example, data point, process from source)
9. Build structured brief (see format below)
10. Write Section 1 (Chapter Introduction) — 200-300 words, template from `sec1-introduction.md`
11. Write Section 2 (Key Terms) — 10-15 terms in table, template from `sec2-key-terms.md`

**No user approval required.** Proceeds straight to Phase 2.

### Phase 2 — Parallel Generation (~3-4 minutes wall clock)

**Agents**: Three sub-agents launched via Task tool IN A SINGLE MESSAGE

#### Agent A: Core Content Writer (Section 3)

**Files to read**:
- `{source_material_path}`
- `references/sections/sec3-core-content.md`
- `references/shared/writing-principles.md`
- Subject file (from v1 path)

**Task prompt structure**:
```
You are writing Section 3 (Core Content) of CBSE Class 9 study notes.

Read these files first:
1. {source_material_path} — the chapter content
2. references/sections/sec3-core-content.md — template and guidelines for this section
3. references/shared/writing-principles.md — writing rules to follow
4. {subject_file_path} — subject-specific topic type patterns and quality guidance

Here is the structured brief from the orchestrator:
{STRUCTURED_BRIEF}

Follow the template in sec3-core-content.md exactly. Use the topic type decision framework
to choose the right explanation style for each sub-section. Include all depth requirements
for the relevant explanation style. Apply the universal rules (bolding, Think About It boxes,
markers, paragraph length, etc.).

Return ONLY the markdown content for Section 3, starting with "## Core Content".
Do not include any other sections.
```

**Expected output**: ~3K-6K words

#### Agent B: Misconceptions Writer (Section 4)

**Files to read**:
- `{source_material_path}`
- `references/sections/sec4-misconceptions.md`
- `references/shared/writing-principles.md`
- Subject file (from v1 path)

**Task prompt structure**:
```
You are writing Section 4 (Common Mistakes & Misconceptions) of CBSE Class 9 study notes.

Read these files first:
1. {source_material_path} — the chapter content
2. references/sections/sec4-misconceptions.md — template and guidelines for this section
3. references/shared/writing-principles.md — writing rules to follow
4. {subject_file_path} — subject-specific common pain points (focus on the "Common Pain Points" section)

Here are the core concepts from the chapter:
{CORE_CONCEPTS_LIST}

Write 4-6 misconceptions following the template in sec4-misconceptions.md.
Source misconceptions from the subject file's "Common Pain Points" section first.
Include at least 2 chapter-specific misconceptions beyond the subject file.
Frame each misconception in the student's language.

Return ONLY the markdown content for Section 4, starting with "## Common Mistakes & Misconceptions".
Do not include any other sections.
```

**Expected output**: ~400-700 words

#### Agent C: Questions & Answers Writer (Section 7)

**Files to read**:
- `{source_material_path}`
- `references/sections/sec7-questions.md`
- `references/exam/exam-patterns.md`
- `references/shared/writing-principles.md`
- Subject file (from v1 path)

**Task prompt structure**:
```
You are writing Section 7 (Questions and Answers) of CBSE Class 9 study notes.

Read these files first:
1. {source_material_path} — the chapter content (includes textbook questions)
2. references/sections/sec7-questions.md — template, question formats, writing guidelines
3. references/exam/exam-patterns.md — CBSE exam structure, answer formats by mark type
4. references/shared/writing-principles.md — writing rules to follow
5. {subject_file_path} — subject-specific exam patterns and sample questions

Here is the structured brief from the orchestrator:
{STRUCTURED_BRIEF}

Write 22+ questions with complete inline answers following sec7-questions.md.
Include textbook end-of-chapter questions from the source with model answers.
Follow exam-patterns.md for answer formats by mark type.
Ensure question deduplication across same-depth types (MCQ/fill-in/1-mark).

Return ONLY the markdown content for Section 7, starting with "## Questions and Answers".
Do not include any other sections.
```

**Expected output**: ~3K-5K words

**Wait for all three to complete before proceeding.**

### Phase 3 — Assemble & Validate (~1-2 minutes)

**Agent**: Main orchestrator agent

1. Read `references/sections/sec5-connections.md`
2. Write Section 5 (Concept Connections) from the structured brief's connections data + template
3. Read Section 3's output to extract sub-section headings
4. Read `references/sections/sec6-quick-revision.md`
5. Read `references/exam/exam-patterns.md` (for examiner tips)
6. Write Section 6 (Quick Revision) — revision table from Section 3 headings + examiner tips
7. Assemble all 7 sections into final markdown file
8. Run quality validation (see checklist below)
9. Save to output path
10. Report stats to user (word count, question count, key terms count, file path)

---

## Structured Brief Format

The orchestrator produces this after Phase 1. It is included verbatim in each Phase 2 Task prompt.

```markdown
## Structured Brief

**Subject:** [Subject] | **Branch:** [Science/Physics if applicable] | **Chapter:** [Chapter Name]
**Variant:** [Narrative/Formula/Process-Classification/Language/Applied]
**Target Word Count:** [from subject file, e.g., 6K-9K]
**Source:** [path to source material]

### Core Concepts
1. [Concept name] — [Topic type: Event/Development, Concept/Definition, Process/Mechanism, Classification, Comparison, Formula/Theorem]
2. [Concept name] — [Topic type]
...

### Key Terms
[Term1], [Term2], [Term3], ... (10-15 terms in order of appearance)

### Core Content Sub-sections
3.1 [Sub-section heading] — [Explanation style]
3.2 [Sub-section heading] — [Explanation style]
3.3 [Sub-section heading] — [Explanation style]
...

### Coverage Checklist
- [Topic/sub-topic from source]
- [Named example or data point]
- [Process/mechanism]
- [Key fact]
...

### Textbook Questions to Include
- "[Question text from source end-of-chapter]"
- "[Question text from source end-of-chapter]"
...

### Concept Connections
Within [Subject]: [Chapter X] ← [how it connects], [Chapter Y] ← [how it connects]
Across Subjects: [Other Subject — Chapter] ← [how it connects]
Real World: [specific application or current event]

### Prerequisites
- [Concept from which chapter/class]
- [Concept from which chapter/class]
```

---

## Context Budget per Agent

| Agent | Context (tokens approx) | What it loads |
|-------|------------------------|---------------|
| Orchestrator (Phase 1) | ~8,000 | SKILL.md + source + subject file + sec3 brief |
| Core Content Agent | ~10,000 | sec3 + writing-principles + subject file + source + brief |
| Misconceptions Agent | ~4,000 | sec4 + writing-principles + subject file + source + concepts list |
| Questions Agent | ~10,000 | sec7 + exam-patterns + writing-principles + subject file + source + brief |
| Orchestrator (Phase 3) | ~5,000 | sec5 + sec6 + exam-patterns + Section 3 output |

**vs v1**: Single agent processed ~20,000 tokens throughout. v2's heaviest agent (Core Content) processes ~10,000 — a 50% reduction.

---

## Quality Validation (Phase 3)

The orchestrator runs these checks after assembly (inline, not a separate agent):

- [ ] All 7 sections present in correct order
- [ ] Total word count within subject target range
- [ ] Section 1 is 200-300 words
- [ ] Section 7 has 22+ questions, all with inline answers
- [ ] All coverage checklist items are addressed in Section 3
- [ ] Section 6 revision table covers all Section 3 sub-sections
- [ ] No concept duplicated across same-depth question types

If a check fails, the orchestrator fixes it inline.

---

## SKILL.md Design

### Frontmatter
```yaml
---
name: cbse-notes-generator
description: "Generate comprehensive, exam-aligned CBSE Class 9 study notes from textbook chapters, PDFs, or raw material. Covers all 9 Class 9 subjects including Mathematics, Science, Social Science, Languages, and Computer Science."
---
```

### Outline of Sections

```
# CBSE Class 9 Study Notes Generator (v2)

## Configuration
- Subject files base path
- Section templates path
- Subject-to-file mapping table

## Step 1 — Gather Inputs
- Source material (file path or pasted content)
- Subject (auto-detect or user-specified)
- Chapter name (auto-detect from source or user-specified)
- Output file path (default: {source_filename}_notes.md)

## Step 2 — Analyze Source Material
- Read source completely
- Stop-and-check validation
- Load subject file
- Extract 8-12 core concepts with topic types
- Build coverage checklist
- Build structured brief

## Step 3 — Generate Sections 1 & 2
- Write Section 1 (Chapter Introduction) — 200-300 words
- Write Section 2 (Key Terms) — 10-15 terms in table

## Step 4 — Parallel Generation (Launch 3 Agents)
- Agent A: Core Content (Section 3) — full Task prompt template
- Agent B: Misconceptions (Section 4) — full Task prompt template
- Agent C: Questions & Answers (Section 7) — full Task prompt template
- Instruction: launch all three in a single message, wait for all

## Step 5 — Assemble & Validate
- Write Section 5 (Concept Connections)
- Write Section 6 (Quick Revision)
- Assemble all 7 sections
- Quality validation checklist
- Save file and report stats

## Edge Cases
- PDF that's hard to read
- Very short source material
- Multiple chapters in one request
- Subject not in supported list

## Subject-to-File Mapping
| Subject | File |
|---------|------|
| Mathematics | ../cbse-notes-creator/cbse-notes-creator/references/subjects/mathematics.md |
| Science — Physics | ../cbse-notes-creator/cbse-notes-creator/references/subjects/science-physics.md |
| Science — Chemistry | ../cbse-notes-creator/cbse-notes-creator/references/subjects/science-chemistry.md |
| Science — Biology | ../cbse-notes-creator/cbse-notes-creator/references/subjects/science-biology.md |
| History | ../cbse-notes-creator/cbse-notes-creator/references/subjects/history.md |
| Geography | ../cbse-notes-creator/cbse-notes-creator/references/subjects/geography.md |
| Economics | ../cbse-notes-creator/cbse-notes-creator/references/subjects/economics.md |
| Political Science | ../cbse-notes-creator/cbse-notes-creator/references/subjects/political-science.md |
| Computer Science | ../cbse-notes-creator/cbse-notes-creator/references/subjects/computer-science.md |
| English | ../cbse-notes-creator/cbse-notes-creator/references/subjects/english.md |
| Hindi | ../cbse-notes-creator/cbse-notes-creator/references/subjects/hindi.md |
```

---

## Changes from v1

| Aspect | v1 | v2 |
|--------|-----|-----|
| Execution model | Sequential single agent | Orchestrator + 3 parallel sub-agents |
| Reference loading | All files upfront (~6K tokens) | Lazy — each agent loads only what it needs |
| User interaction | Outline approval + section-by-section option | No approval gates — straight through |
| Sections 1 & 2 | Generated during full write | Generated by orchestrator in Phase 1 |
| Sections 3, 4, 7 | Generated sequentially | Generated in parallel (Phase 2) |
| Sections 5, 6 | Generated sequentially | Generated during assembly (Phase 3) |
| Quality checks | During writing + post-write | Post-assembly validation only |
| Context per agent | ~20K tokens (single agent) | ~4K-10K tokens (per agent) |
| Estimated time | 10-12 minutes | ~5-6 minutes |

---

## Risks & Mitigations

| Risk | Impact | Mitigation |
|------|--------|------------|
| Parallel agents produce inconsistent tone/style | Medium | Shared `writing-principles.md` loaded by all agents; subject file loaded by all agents |
| Sub-agent output doesn't match expected format | Medium | Explicit "return ONLY markdown for Section X" constraint in each prompt; templates are prescriptive |
| Subject file has info needed by multiple agents | Low | Each agent loads the full subject file (only ~75 lines/~1K tokens) — duplication cost is negligible |
| Coverage gaps between Core Content and Questions | Medium | Structured brief includes coverage checklist; Questions agent receives the same checklist |
| Phase 3 assembly stitching reads poorly at section boundaries | Low | Section templates include explicit separator conventions (`---` between sections); assembly agent can add transition text |
| Relative path to v1 subjects breaks if v1 folder moves | Low | Document in PLAN.md; user can update the base path in SKILL.md Configuration section |

---

## Implementation Order

1. Create folder structure (`references/shared/`, `references/sections/`, `references/exam/`)
2. Create `references/shared/writing-principles.md`
3. Create section reference files (sec1 through sec7) — extracted from v1 universal-template.md
4. Create `references/exam/exam-patterns.md` — copy from v1 with terminology fix
5. Create `SKILL.md` — the orchestrator with 3-phase workflow
6. Test with a sample chapter to validate end-to-end flow
