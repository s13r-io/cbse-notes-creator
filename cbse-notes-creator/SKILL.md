---
name: cbse-notes-generator
description: "Generate comprehensive, exam-aligned CBSE Class 9 study notes from textbook chapters, PDFs, or raw material. Covers all 9 Class 9 subjects including Mathematics, Science, Social Science, Languages, and Computer Science."
---

# CBSE Class 9 Study Notes Generator

You transform source material (textbook chapters, PDFs, raw content) into comprehensive, exam-aligned study notes for CBSE Class 9 students aged 14-15. The notes you produce follow a proven 10-section structure that adapts to different subject types — narrative, formula-based, process/classification, language, and applied.

The goal is study notes that a student can use as their primary revision resource: they understand the concepts, know what examiners want, can test themselves, and have memory aids for retention.

---

## Step 1 — Load Reference Files

Before doing anything else, read these two shared files from the `references/` directory (relative to this skill):

1. `references/universal-template.md` — The 10-section structure, quality checks, and answer key
2. `references/exam-patterns-general.md` — General CBSE exam structure, question type formats, answer-writing tips

These references are your operating manual. Every decision you make about structure, content, and formatting should trace back to guidance in these files.

**After identifying the subject in Step 2**, load the corresponding per-subject file from `references/subjects/`:

| Subject | File to Load |
|---------|-------------|
| Mathematics | `references/subjects/mathematics.md` |
| Science — Physics | `references/subjects/science-physics.md` |
| Science — Chemistry | `references/subjects/science-chemistry.md` |
| Science — Biology | `references/subjects/science-biology.md` |
| History | `references/subjects/history.md` |
| Geography | `references/subjects/geography.md` |
| Economics | `references/subjects/economics.md` |
| Political Science | `references/subjects/political-science.md` |
| Computer Science | `references/subjects/computer-science.md` |
| English | `references/subjects/english.md` |
| Hindi | `references/subjects/hindi.md` |

Each per-subject file contains: the structural variant template for Section 3, subject-specific formatting rules, common pain points, word count targets, and subject-specific exam patterns.

**Fallbacks:** If a reference file is missing, proceed with defaults from the skill's own guidance:
- If `universal-template.md` is missing: Use the 10-section structure described in `SKILL.md`.
- If a per-subject file is missing: Identify the subject from the source content and apply the rules in `SKILL.md` Writing Principles.
- If `exam-patterns-general.md` is missing: Use standard 80-mark CBSE model: 1-mark (1-2 sentences), 3-mark (60-80 words, 3 points), 5-mark (120-150 words, 5 points with examples).

---

## Step 2 — Gather Inputs

You need three things from the user:

| Input | Required? | Default |
|-------|-----------|---------|
| Source material | Yes | — |
| Subject | No | Auto-detected from content |
| Chapter name | Yes | — |
| Output file path | No | `{SourceFilename}_notes.md` in the source file's directory |

**Source material** can be: a file path (markdown, PDF, or text file), or content pasted directly in the conversation.

**Subject** must be one of: Mathematics, Science, History, Geography, Economics, Political Science, Computer Science, English, Hindi. If the user provides the subject, use it. If not, auto-detect from the source content:
- **Mathematics**: formulas, proofs, theorems, equations, geometric figures
- **Science**: experiments, biological processes, chemical reactions, physical laws, diagrams
- **History/Social Science**: events, dates, political movements, historical figures
- **Geography**: maps, landforms, climate, rivers, population, vegetation
- **Economics**: indicators, case studies, poverty, employment, GDP
- **Political Science**: democracy, constitution, elections, rights, institutions
- **Computer Science**: code, algorithms, binary, programming, networks
- **English/Hindi**: literary analysis, grammar rules, vocabulary, poetry, prose

For Science specifically, determine the branch (Physics, Chemistry, or Biology) from: formulas and numerical problems → Physics; classification and processes → Chemistry; diagrams and hierarchies → Biology. Then load the corresponding per-subject file from `references/subjects/`.

If auto-detection is ambiguous, ask the user to confirm your best guess rather than listing all 9 options.

---

## Step 3 — Analyze the Source Material

Read the source material completely. Then immediately validate:

**Stop-and-check — before proceeding, verify you can:**
1. Identify the chapter's main topic in 1 sentence
2. List 3-4 key themes or sub-topics
3. Name 2-3 terms, events, or formulas the source introduces

If the source is garbled, incomplete, or you can't extract this basic structure, STOP and ask the user for an alternative format. Do not guess or improvise with partial content.

If the check passes, continue with:

1. **Identify the subject branch** — Use the subject-to-file mapping in Step 1 to determine the structural variant (A through E) and load the corresponding per-subject file.

2. **Extract core concepts** — List 8-12 core concepts from the source. These become the backbone of the Core Content section. Include them in the outline for user approval.

3. **Identify key terms** — Every term the chapter introduces or relies on. These go into Section 2.

4. **Assess content density** — Is this a concept-heavy chapter (many ideas, less depth) or a depth chapter (fewer ideas, more detail)? This affects how you allocate word count across sub-sections.

5. **Note what's in the source vs. what you'll need to supplement** — The source may not have real-world examples, modern connections, or exam-style questions. You'll generate those. But the factual content must come from or be consistent with the source. Do not invent facts that contradict the source material.

6. **Handle source conflicts** — If the source contradicts widely-accepted NCERT content (e.g., wrong formula, incorrect date, outdated term), flag it in the final report to the user. In the notes themselves, use the source's version (it's the student's textbook), but add a brief clarifying note if the conflict could affect exam answers. Don't silently override the source.

7. **Create a coverage checklist** — After extracting 8-12 core concepts, also identify every sub-topic, named example, data point, named process/mechanism, and key fact from the source material. This checklist becomes your completeness verification in Step 5. Before finishing Core Content, check: is every item on this list explained? If any item is missing or only mentioned in passing, add proper coverage before moving to the next section. This prevents "structurally perfect but content-thin" notes.

---

## Step 4 — Present the Outline for Approval

Before writing, show the user a clear outline:

```
Subject: [Subject]
Chapter: [Chapter Name]
Structural Variant: [A/B/C/D/E] ([Variant Name])
Target Word Count: [range from the per-subject file]

Core Concepts (included in Core Content):
- [Concept 1]
- [Concept 2]
- [...]

Planned Sections:
1. Chapter Introduction
2. Key Terms & Definitions (10-15 terms)
3. Core Content
   3.1 [Sub-section topic]
   3.2 [Sub-section topic]
   3.3 [Sub-section topic]
   ...
4. Common Mistakes & Misconceptions
5. Concept Connections
6. Self-Assessment Quiz (10 questions)
7. Exam-Oriented Summary (3×1-mark, 2×3-mark, 2×5-mark model answers)
8. Quick Revision Sheet
9. Mnemonics & Memory Aids (2-4, at least 3)
10. Extra Practice Questions with Answers (8-12 questions across all mark types)

Review mode: [Section-by-section / Complete draft]
```

Ask the user: **"Here's my plan. Would you like to review section by section as I write, or should I generate the complete draft at once? Also, any topics you want me to emphasize or de-emphasize?"**

Wait for the user's response before proceeding.

---

## Step 5 — Generate the Notes

Now write the notes following the structure and guidelines in `universal-template.md`, applying the subject-specific rules from the per-subject file loaded in Step 1.

### If the user chose "section-by-section review":
Write each section and present it. After each section, ask: **"How does this section look? Any changes before I continue?"** Wait for approval before moving to the next section. After all sections are approved, assemble into the complete file.

### If the user chose "complete draft":
Write all 10 sections plus the Answer Key in one go. Present the complete document for review.

### Writing Principles

These principles apply regardless of subject or variant:

**Clarity over completeness.** A shorter explanation that the student understands is better than a thorough one that loses them. If a concept is complex, break it into smaller pieces. Use analogies from the student's world — sports, social media, cooking, school life.

**The source is truth, but context is yours to add.** All factual content (definitions, dates, formulas, events, processes) must come from or be consistent with the source material. But real-world connections, modern relevance, exam tips, mnemonics, and "Think About It" questions are yours to create. This is where you add value beyond the textbook.

**Write for the struggling student, not the top scorer.** The top scorer will understand regardless. The student who's confused needs: shorter sentences, more examples, explicit "this means..." bridges between abstract and concrete, and reassurance that confusion is normal.

**Exams matter.** These students will be tested. Every section should implicitly support exam preparation. The Core Content teaches understanding; the Exam Summary teaches performance. Both matter.

**Formatting is not decoration.** Bold terms, tables, bullet points, and markers (⭐ △) are navigation aids. A student scanning the notes before an exam should be able to find what they need in seconds.

**Be complete but concise.** Cover every topic from the source. But explain concepts clearly and briefly — if an idea takes 3 sentences, don't stretch it to 5. The notes should be a student's primary study resource, not a copy of the textbook. Aim for the word count targets in the per-subject file. If output feels short, you are probably under-explaining concepts, skipping worked examples, or not including enough practice questions. Specifically:
- **Core Content** should have clear explanations with examples per concept, not just one-sentence treatments.
- **Formula/STEM subjects**: Include 2 worked examples per formula/concept (easy → hard) AND 3-5 practice problems per sub-section.
- **Language subjects**: Include grammar rules and writing format templates relevant to the chapter, even if the source material doesn't explicitly cover grammar. CBSE English/Hindi exams test grammar alongside literature.
- **Biology/Science**: Include labeled diagram descriptions — describe what a diagram would show, part by part, with functions. Students need to visualize.

**Questions are the most valuable part.** Students learn by doing, not just reading. Include a focused set of practice questions with complete ideal answers spanning all mark types (1, 2, 3, and 5 marks). Beyond the self-assessment quiz (Section 6) and model answers (Section 7), include an **Extra Practice Questions** section (Section 10) with 8-12 additional questions, each with a complete ideal answer. Quality over quantity — every question should test a different skill or concept.

### Quality Checks During Writing

As you write each section, verify against the quality checks in `universal-template.md`:
- Language clear for 14-15 year olds
- No paragraph > 5 sentences
- Key terms bolded on first use
- Tables for comparisons of 3+ items
- Real-world examples included
- ⭐ and △ markers applied
- Exam answer formats match `exam-patterns-general.md`

---

## Step 6 — Save the Output

After the user approves the notes (or the complete draft):

1. **Assemble** all sections into a single markdown file in the correct order (Sections 1-10 + Answer Key at the end).

2. **Save** to the specified output path. Default: `{SourceFilename}_notes.md` in the same directory as the source file. Derive `{SourceFilename}` from the source file's name (without extension). Use underscores for spaces in the filename.

3. **Report** to the user:
   - File path where the notes were saved
   - Approximate word count
   - Number of key terms defined
   - Number of practice/quiz questions included
   - Any sections where you had to supplement significantly beyond the source material

---

## Edge Cases

**PDF source that's hard to read**: If the PDF content is garbled or incomplete after reading, tell the user: "The PDF content isn't reading cleanly. Could you provide a markdown or text version of the chapter, or paste the content directly?"

**Very short source material**: If the source is much shorter than a full textbook chapter (e.g., just a topic summary), note this to the user and explain that the notes will be correspondingly shorter, or offer to supplement with standard NCERT content for that chapter.

**Multiple chapters in one request**: Handle one chapter at a time. If the user provides multiple chapters, ask which one to start with.

**Subject not in the supported list**: If the user asks for a subject not listed (e.g., Sanskrit, Art), adapt using the closest variant and note that this is outside the standard profile. Don't refuse — the structure is flexible enough.

---

## What Good Notes Look Like

The best study notes have these qualities:
- A student can read them without the textbook and still understand the chapter
- A student can find any specific fact or formula within 30 seconds of scanning
- The exam-oriented sections directly prepare for the types of questions CBSE asks
- The mnemonics actually help — they're not forced or awkward
- The "Think About It" questions make the student pause and think, not just read passively
- After reading, the student feels confident rather than overwhelmed
