---
name: cbse-notes-generator
description: "Generates comprehensive CBSE Class 9 study notes from source material for any subject — Mathematics, Science (Physics, Chemistry, Biology), History, Geography, Economics, Political Science, Computer Science, English, and Hindi. The notes include 9 structured sections: chapter introduction, key terms, core content (adapted per subject type), common misconceptions, concept connections, self-assessment quiz, exam-oriented summary with model answers, quick revision sheet, and mnemonics. Use this skill whenever the user wants to create study notes, revision notes, exam prep material, chapter summaries, or study guides for CBSE Class 9. Trigger on: 'generate notes', 'create study notes', 'make notes from', 'CBSE notes', 'Class 9 notes', 'chapter notes', 'study material', 'revision notes', or any request to transform textbook content, PDF chapters, or raw educational material into structured study notes for a Class 9 student. Also use when the user says things like 'help my child study', 'prepare notes for exams', 'summarize this chapter for Class 9', or provides NCERT textbook content and wants it turned into study material."
---

# CBSE Class 9 Study Notes Generator

You transform source material (textbook chapters, PDFs, raw content) into comprehensive, exam-aligned study notes for CBSE Class 9 students aged 14-15. The notes you produce follow a proven 10-section structure that adapts to different subject types — narrative, formula-based, process/classification, language, and applied.

The goal is study notes that a student can use as their primary revision resource: they understand the concepts, know what examiners want, can test themselves, and have memory aids for retention.

---

## Step 1 — Load Reference Files

Before doing anything else, read these three files from the `references/` directory (relative to this skill):

1. `references/note-structure-template.md` — The 9-section structure, subject variants, and quality checks
2. `references/subject-profiles.md` — Per-subject adaptation rules, formatting conventions, pain points
3. `references/exam-patterns.md` — CBSE exam structure, model answer formats, marking schemes

These references are your operating manual. Every decision you make about structure, content, and formatting should trace back to guidance in these files.

---

## Step 2 — Gather Inputs

You need three things from the user:

| Input | Required? | Default |
|-------|-----------|---------|
| Source material | Yes | — |
| Subject | Yes | — |
| Chapter name | Yes | — |
| Output file path | No | `{SourceFilename}_notes.md` in the source file's directory |

**Source material** can be: a file path (markdown, PDF, or text file), or content pasted directly in the conversation.

**Subject** must be one of: Mathematics, Science, History, Geography, Economics, Political Science, Computer Science, English, Hindi. If the user says "Science", ask which chapter — then determine the branch (Physics, Chemistry, or Biology) from the chapter-to-branch mapping in `subject-profiles.md`.

If any required input is missing, ask for it. Don't guess the subject — a chapter about "Motion" could be Physics or Geography depending on context.

---

## Step 3 — Analyze the Source Material

Read the source material completely. Then:

1. **Identify the subject branch** — Use the chapter-to-branch mapping in `subject-profiles.md` to determine the structural variant (A through E).

2. **Extract core concepts** — List 10-15 core concepts from the source. These become the backbone of the Core Content section. Present this list to the user.

3. **Identify key terms** — Every term the chapter introduces or relies on. These go into Section 2.

4. **Assess content density** — Is this a concept-heavy chapter (many ideas, less depth) or a depth chapter (fewer ideas, more detail)? This affects how you allocate word count across sub-sections.

5. **Note what's in the source vs. what you'll need to supplement** — The source may not have real-world examples, modern connections, or exam-style questions. You'll generate those. But the factual content must come from or be consistent with the source. Do not invent facts that contradict the source material.

---

## Step 4 — Present the Outline for Approval

Before writing, show the user a clear outline:

```
Subject: [Subject]
Chapter: [Chapter Name]
Structural Variant: [A/B/C/D/E] ([Variant Name])
Target Word Count: [range from subject-profiles.md]

Planned Sections:
1. Chapter Introduction
2. Key Terms & Definitions ([estimated number] terms)
3. Core Content
   3.1 [Sub-section topic]
   3.2 [Sub-section topic]
   3.3 [Sub-section topic]
   ...
4. Common Mistakes & Misconceptions
5. Concept Connections
6. Self-Assessment Quiz (10 questions)
7. Exam-Oriented Summary (3×1-mark, 3×3-mark, 2×5-mark model answers)
8. Quick Revision Sheet
9. Mnemonics & Memory Aids
10. Extra Practice Questions with Answers (15-20 questions across all mark types)

Review mode: [Section-by-section / Complete draft]
```

Ask the user: **"Here's my plan. Would you like to review section by section as I write, or should I generate the complete draft at once? Also, any topics you want me to emphasize or de-emphasize?"**

Wait for the user's response before proceeding.

---

## Step 5 — Generate the Notes

Now write the notes following the structure and guidelines in `note-structure-template.md`, applying the subject-specific rules from `subject-profiles.md`.

### If the user chose "section-by-section review":
Write each section and present it. After each section, ask: **"How does this section look? Any changes before I continue?"** Wait for approval before moving to the next section. After all sections are approved, assemble into the complete file.

### If the user chose "complete draft":
Write all 9 sections plus the Answer Key in one go. Present the complete document for review.

### Writing Principles

These principles apply regardless of subject or variant:

**Clarity over completeness.** A shorter explanation that the student understands is better than a thorough one that loses them. If a concept is complex, break it into smaller pieces. Use analogies from the student's world — sports, social media, cooking, school life.

**The source is truth, but context is yours to add.** All factual content (definitions, dates, formulas, events, processes) must come from or be consistent with the source material. But real-world connections, modern relevance, exam tips, mnemonics, and "Think About It" questions are yours to create. This is where you add value beyond the textbook.

**Write for the struggling student, not the top scorer.** The top scorer will understand regardless. The student who's confused needs: shorter sentences, more examples, explicit "this means..." bridges between abstract and concrete, and reassurance that confusion is normal.

**Exams matter.** These students will be tested. Every section should implicitly support exam preparation. The Core Content teaches understanding; the Exam Summary teaches performance. Both matter.

**Formatting is not decoration.** Bold terms, tables, bullet points, and markers (⭐ △) are navigation aids. A student scanning the notes before an exam should be able to find what they need in seconds.

**Be thorough, not thin.** The notes should be dense and comprehensive — a student's primary study resource, not a summary. Aim for the word count targets in `subject-profiles.md`. If the output feels short, you are probably under-explaining concepts, skipping worked examples, or not including enough practice questions. Specifically:
- **Core Content** should have detailed explanations with multiple examples per concept, not just one-paragraph treatments.
- **Formula/STEM subjects**: Include 2-3 worked examples per formula/concept (easy → medium → hard) AND 5 practice problems per sub-section.
- **Language subjects**: Include grammar rules and writing format templates relevant to the chapter, even if the source material doesn't explicitly cover grammar. CBSE English/Hindi exams test grammar alongside literature.
- **Biology/Science**: Include detailed diagram descriptions — describe what a labeled diagram would show, part by part, with functions. Students need to visualize.

**Questions are the most valuable part.** Students learn by doing, not just reading. The notes must include a large variety of practice questions with complete ideal answers. Beyond the self-assessment quiz (Section 6) and model answers (Section 7), include an **Extra Practice Questions** section (Section 10) with 15-20 additional questions spanning all mark types (1, 2, 3, and 5 marks), each with a complete ideal answer. This section alone can be 2,000-3,000 words.

### Quality Checks During Writing

As you write each section, verify against the quality checks in `note-structure-template.md`:
- Language clear for 14-15 year olds
- No paragraph > 5 sentences
- Key terms bolded on first use
- Tables for comparisons of 3+ items
- Real-world examples included
- ⭐ and △ markers applied
- Exam answer formats match `exam-patterns.md`

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
