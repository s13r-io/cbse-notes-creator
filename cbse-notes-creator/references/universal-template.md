# CBSE Class 9 Study Notes — Universal Structure Template

This template defines the mandatory sections and quality checks for generating study notes. Every set of notes must include all 7 numbered sections.

**Subject-specific content** (topic-type patterns, quality guidance, subject profile rules, and subject exam patterns) is loaded from the per-subject file in `references/subjects/`.

---

## Table of Contents

1. [Mandatory Sections Overview](#mandatory-sections-overview)
2. [Section 1: Chapter Introduction](#section-1-chapter-introduction)
3. [Section 2: Key Terms & Definitions](#section-2-key-terms--definitions)
4. [Section 3: Core Content](#section-3-core-content)
5. [Section 4: Common Mistakes & Misconceptions](#section-4-common-mistakes--misconceptions)
6. [Section 5: Concept Connections](#section-5-concept-connections)
7. [Section 6: Quick Revision](#section-6-quick-revision)
8. [Section 7: Questions and Answers](#section-7-questions-and-answers)
9. [Quality Checks](#quality-checks)

---

## Mandatory Sections Overview

Every generated note must contain these 7 sections in this order:

| # | Section | Purpose | Approximate Length |
|---|---------|---------|-------------------|
| 1 | Chapter Introduction | Chapter structure outline, prerequisites, why it matters | **200-300 words max** |
| 2 | Key Terms & Definitions | Quick-reference glossary | 10-15 terms |
| 3 | Core Content | Main body — source-driven, flexible structure | Substantive explanations for every topic |
| 4 | Common Mistakes & Misconceptions | Prevent common errors | 4-6 items |
| 5 | Concept Connections | Link to other chapters/subjects | 200-400 words |
| 6 | Quick Revision | Top things to remember, revision table, examiner's tips | 400-700 words |
| 7 | Questions and Answers | All question types with inline answers | 22+ questions |

---

## Section 1: Chapter Introduction

### Purpose
Give the student a roadmap of the chapter in under 300 words. They should know what topics are covered, in what order, and whether they have the prerequisites. **This section must be 200-300 words. Do not exceed 300 words.**

### Structure

```markdown
# [Chapter Name] — [Subject]
## CBSE Class 9 | Comprehensive Study Notes

### Chapter Overview
[2-3 sentences: a hook (surprising fact or question) + what this chapter is about + why it matters. No jargon.]

### Chapter Structure
This chapter covers these topics in this order:
1. **[Topic Name]** — [One clause: what this topic covers]
2. **[Topic Name]** — [One clause]
3. **[Topic Name]** — [One clause]
4. **[Topic Name]** — [One clause]
...

### Prerequisites
- [Concept 1 — from which chapter/class]
- [Concept 2 — from which chapter/class]
- [If no prerequisites: "This chapter starts from the basics. No prior knowledge needed."]
```

### Writing Guidelines
- The overview paragraph is the hook — make the student curious with a surprising fact, a question, or a real-world scenario.
- The chapter structure list must match the actual sub-sections in Section 3 (Core Content). Do not list topics here that don't appear in Core Content, and vice versa.
- Prerequisites should be honest — if a student needs Class 8 algebra to follow this Math chapter, say so.
- **Hard constraint**: This section must be between 200 and 300 words. If you're approaching 300, cut the prerequisites or shorten the overview. Do not pad.

---

## Section 2: Key Terms & Definitions

### Purpose
A scannable glossary the student can refer back to while reading. Definitions should make sense on their own, without needing to read the full chapter first.

### Structure

```markdown
## Key Terms & Definitions

| Term | Definition | Example / Context |
|------|-----------|-------------------|
| **[Term 1]** | [Simple definition, max 2 sentences] | [Concrete example or where it appears] |
| **[Term 2]** | [...] | [...] |
```

### Writing Guidelines
- Arrange terms in the order they appear in the chapter, not alphabetically. This creates a narrative flow even in the glossary.
- Each definition must stand alone — a student should understand it without having read anything else.
- The Example/Context column is where you connect abstract terms to concrete reality.
- For Hindi chapters: include the Hindi term in Devanagari with English transliteration. For Science: include the English term even if explaining in another language.
- For Math/Science: if the term involves a formula, include it in the definition.
- Aim for 10-15 terms. If a chapter has fewer than 10 key terms, that's fine — don't pad.

---

## Section 3: Core Content

This is the main body of the notes. Unlike earlier templates, this section does NOT use a fixed "What it is / How it works / Effects" structure. Instead, the explanation style must match the topic type.

### Step 1: Determine the Explanation Style for Each Topic

Before writing, classify each sub-topic from the source material using this framework:

| Topic Type | Explanation Style | Use When |
|------------|-----------------|----------|
| Event/Development | Sequence of Events (chronological) | Green Revolution, French Revolution, PDS evolution, independence movements |
| Concept/Definition | Define → Explain → Apply | Food security, democracy, climate, types of government, cell theory |
| Process/Mechanism | Cause-Effect Chain (steps with reasons) | Monsoon mechanism, photosynthesis, osmosis, soil formation, nitrogen cycle |
| Classification | Category Breakdown (tree or table) | Tissue types, soil types, economic sectors, types of angles, parts of speech |
| Comparison | Side-by-Side Analysis (table + narrative) | Plant vs animal cell, rural vs urban, primary vs secondary sector |
| Formula/Theorem | Intuition → Statement → Worked Examples | Any math/physics formula, quadratic formula, Pythagoras theorem |

**A single sub-section can combine multiple styles.** For example, explaining "The Green Revolution" uses: Concept (define it) → Sequence of Events (chronology) → Comparison (before vs after) → Cause-Effect (positive and negative impacts).

### Step 2: Follow the Source Material's Sequence

Organize Core Content sub-sections in the **same order as the source material (textbook chapter)**. Do not reorder topics unless the source itself jumps around confusingly. The chapter structure you listed in Section 1 must match what appears here.

### Step 3: Apply Depth Minimums by Explanation Style

Each explanation style has minimum depth requirements. These are not optional:

**Sequence of Events**
- "Why it Started" (2-3 sentences explaining the trigger/cause)
- 4+ chronological stages with years/dates where applicable
- Impact table: | Group/Region | Effect | Why it matters |
- "Problems/Limitations" sub-heading (every historical event has downsides)

**Concept/Definition**
- Definition (1-2 sentences, bold key terms)
- Explanation (150-250 words on "how" it works and "why" it matters)
- Application: 1 real-world example + 1 exam-relevant scenario
- "Think About It" box (1 per sub-section, see below)

**Process/Mechanism**
- 5-8 numbered steps, each with WHAT happens AND WHY it happens
- For geography: include spatial references (locations, directions, altitude)
- Input → Output summary: what goes in, what comes out, what changes

**Classification**
- Tree structure or nested list with 3+ items per level
- Each item has: name + distinguishing characteristic + example
- A comparison table if the categories are commonly confused

**Comparison**
- Side-by-side table with 4+ aspects
- Narrative paragraph on the most important differences (the ones that matter for exams)
- A decision rule: "To tell X apart from Y, look for Z"

**Formula/Theorem**
- "The Big Idea" intuition (what problem does this solve, in everyday language)
- Formal statement with variable definitions and units
- 2-3 graded worked examples (easy → medium → hard)
- Each worked example includes a "Why this approach?" sentence before the solution
- Common calculation errors box (see below)

### Step 4: Label Everything with Headings

**No undifferentiated paragraphs.** Every explanation must have labeled parts using H3/H4 headings. Students should be able to scan the headings and understand the structure.

Good: `### Why the Revolution Began`, `### Impact on Different Groups`, `### Limitations`
Bad: A 300-word block of text with no sub-headings

### Universal Rules (Apply to ALL Topic Types)

1. **Sub-sections**: Break Core Content into 3-6 sub-sections based on natural topic divisions in the source material. Each sub-section = one major topic from the chapter.
2. **Bold key terms** on first use in Core Content (even if already defined in Section 2).
3. **Bullet points** for lists of 3+ items.
4. **"Think About It" boxes**: Include 1 per sub-section.
   ```markdown
   > **THINK Think About It:** [Question that makes the student apply the concept they just read about — not a recall question, but an extension or "what if" question]
   ```
5. **Frequently tested markers**: Mark concepts that appear often in exams with ⭐ at the start of the paragraph/point. Mark important but rarely tested concepts with △.
6. **No paragraph longer than 5 sentences.** If you need more, break into two paragraphs or use bullet points.
7. **Progressive scaffolding**: Within each sub-section, start with the simplest idea and build to the most complex. Don't start with exceptions, edge cases, or advanced applications.

### Common Calculation Errors Box (Math/Science)

```markdown
> **⚠️ Watch Out:** [Describe a common error — e.g., "Students often forget to convert km/h to m/s before using the formula. Always check your units first!"]
```

Include 1 per sub-section where calculations or formulas are involved.

### "In Today's World" Connections (Social Science)

```markdown
> **[WORLD] In Today's World:** [1-2 sentences connecting a concept to current events — name a specific policy, event, or phenomenon. Not generic.]
```

Include 1-2 per chapter where real-world relevance is strong (History, Geography, Economics, Political Science).

---

## Section 4: Common Mistakes & Misconceptions

### Purpose
Prevent errors before they happen. Students learn as much from "what NOT to do" as from "what to do."

### Structure

```markdown
## Common Mistakes & Misconceptions

| # | Misconception / Mistake | Why It's Wrong | Correct Understanding |
|---|------------------------|----------------|----------------------|
| 1 | [What students commonly think or do wrong] | [Brief explanation of why] | [What they should think/do instead] |
| 2 | ... | ... | ... |
```

### Writing Guidelines
- Include 4-6 items per chapter.
- **Source the misconceptions from the per-subject file's "Common Pain Points" section first.** These are verified student errors for the subject. Supplement with 1-2 misconceptions specific to THIS chapter's content.
- Frame the misconception in the student's language — write it as they would say it.
- The "Correct Understanding" column should be memorable and clear.
- For Math/Science: include at least 2 calculation-specific errors.

---

## Section 5: Concept Connections

### Purpose
Show the student that knowledge isn't isolated. This chapter connects to other chapters, other subjects, and the real world. This builds deeper understanding and helps with analytical questions in exams.

### Writing Guidelines
- Each connection must name a **specific chapter** (not just a subject) and explain **how** it connects in 1 sentence. Vague connections like "connects to Science" are not useful.
- "In the Real World" connections must be **specific and verifiable** — name a country, event, technology, or phenomenon. Avoid generic statements like "used in everyday life."

### Structure

```markdown
## How This Chapter Connects

### Within [Subject Name]
- **[Chapter X]** ← [How it connects — 1 sentence]
- **[Chapter Y]** ← [How it connects]

### Across Subjects
- **[Other Subject — Chapter]** ← [How it connects]
- **[Other Subject — Chapter]** ← [How it connects]

### In the Real World
- [Real-world application or current event — 1-2 sentences]
- [Another connection]

### Concept Map
[Topic Name]
├── connects to → [Related Concept 1] (same subject)
│   └── because → [brief reason]
├── connects to → [Related Concept 2] (different subject)
│   └── because → [brief reason]
└── applies to → [Real-world application]
    └── example → [specific example]
```

---

## Section 6: Quick Revision

### Purpose
This is the section students return to most before exams. Dense, scannable, and directly aligned with what examiners test. It contains only revision material — no practice questions or model answers (those go in Section 7).

### Structure

```markdown
## Quick Revision

### Top [X] Things to Remember
1. ⭐ [Most important point — 1-2 sentences]
2. ⭐ [Second most important]
3. [...]
...

### Quick Revision Table

| Topic | Key Points | Exam Relevance |
|-------|-----------|----------------|
| **[Sub-section 1 name]** | [2-3 bullet points] | [What type of question to expect] |
| **[Sub-section 2 name]** | [2-3 bullet points] | [...] |
| **[Sub-section 3 name]** | [2-3 bullet points] | [...] |

### Examiner's Tips for This Chapter
- [Specific tip about what examiners look for in this chapter]
- [Common reason students lose marks in this chapter]
- [How to structure answers for this chapter's typical questions]
- [Any special instructions (draw diagram, mention dates, show units)]
```

### Writing Guidelines
- **Top X Things to Remember**: X should be 6-10 depending on chapter density. Focus on the most exam-relevant points — the ones a student must know regardless of which question appears. Use ⭐ for the 3-4 most critical ones.
- **Quick Revision Table**: One row per Core Content sub-section. Every sub-section from Section 3 must appear here. Key points should be the 2-3 facts most likely to be asked in an exam. Exam relevance column tells the student what type of question to expect for that topic.
- **Examiner's Tips**: 3-4 specific tips for THIS chapter, not generic exam advice. Include answer-writing tips from `exam-patterns-general.md` that are specifically relevant to this chapter's question types.
- For Math: tips about showing working, units, and common calculation errors.
- For History: tips about including dates, names, and places in answers.
- For Science: tips about labeled diagrams and key terms.
- Keep the entire section between 400-700 words. This is a revision summary, not a rewrite of the chapter.

---

## Section 7: Questions and Answers

### Purpose
This is the practice section — all questions in one place, ordered by question type to mirror the exam paper structure. Every question is followed immediately by its complete ideal answer. No separate answer key.

### Structure

```markdown
## Questions and Answers

### Multiple Choice

**Q1.** [Question]
(a) [Option]  (b) [Option]  (c) [Option]  (d) [Option]
**A:** (a) [Correct option] — [Brief explanation if the correct answer isn't self-evident]

**Q2.** [Question]
(a) [Option]  (b) [Option]  (c) [Option]  (d) [Option]
**A:** (c) [Correct option] — [Brief explanation]

**Q3.** [Question]
(a) [Option]  (b) [Option]  (c) [Option]  (d) [Option]
**A:** (b) [Correct option] — [Brief explanation]

**Q4.** [Question]
(a) [Option]  (b) [Option]  (c) [Option]  (d) [Option]
**A:** (d) [Correct option] — [Brief explanation]

### Fill in the Blanks

**Q5.** [Sentence with _______ for the blank]
**A:** [Answer]

**Q6.** [Sentence with _______ for the blank]
**A:** [Answer]

**Q7.** [Sentence with _______ for the blank]
**A:** [Answer]

### Assertion-Reason

**Q8.** **Assertion (A):** [Statement — concept from the chapter]
**Reason (R):** [Statement — reason related to the assertion]
(a) Both A and R are true and R is the correct explanation of A
(b) Both A and R are true but R is NOT the correct explanation of A
(c) A is true but R is false
(d) A is false but R is true
**A:** (a) [Correct option] — [Explanation of why this option is correct]

### 1-Mark Questions

**Q9.** [Question]
**A:** [Complete ideal answer — 1-2 sentences, precise]

**Q10.** [Question]
**A:** [Complete ideal answer]

**Q11.** [Question]
**A:** [Complete ideal answer]

**Q12.** [Question]
**A:** [Complete ideal answer]

### 2-Mark Questions

**Q13.** [Question]
**A:**
1. [Point 1]
2. [Point 2]

**Q14.** [Question]
**A:**
1. [Point 1]
2. [Point 2]

**Q15.** [Question]
**A:**
1. [Point 1]
2. [Point 2]

### 3-Mark Questions

**Q16.** [Question]
**A:**
[Direct answer — 1 sentence]
1. [Point 1 with explanation]
2. [Point 2 with explanation]
3. [Point 3 with example]

**Q17.** [Question]
**A:**
[Same format — 3 distinct points]

**Q18.** [Question]
**A:**
[Same format — 3 distinct points]

### 5-Mark Questions

**Q19.** [Question]
**A:**
[Introduction — 1 sentence framing the topic]
1. [Point 1 with explanation]
2. [Point 2 with explanation]
3. [Point 3 with example]
4. [Point 4 with example or data]
5. [Conclusion or additional point]

**Q20.** [Question]
**A:**
[Same format — 5 distinct points with examples]

### Case-Based / Source-Based Questions

**Q21.** [Provide a passage, data table, scenario, or diagram description — 2-3 sentences]

**21a.** [Question requiring identification of the concept — 1 mark]
**21b.** [Question requiring application of the concept to the case — 1 mark]
**21c.** [Question requiring analysis or inference from the case — 2 marks]

**A21a:** [Answer — 1 sentence]
**A21b:** [Answer — 1-2 sentences linking the case to the concept]
**A21c:**
[Direct answer — 1 sentence]
1. [Point with explanation]
2. [Point with reference to the case]
```

### Writing Guidelines

**Every question must have a complete ideal answer immediately after it.** No exceptions. The answer should be exactly what a student should write in an exam to get full marks.

**Question ordering**: Follow the structure above — Multiple Choice → Fill in the Blanks → Assertion-Reason → 1-Mark → 2-Mark → 3-Mark → 5-Mark → Case-Based. This mirrors the exam paper and makes it easy for students to find specific question types.

**Question count**: Minimum 22 questions total. No upper cap — include as many as needed for comprehensive coverage. Aim for:
- Multiple Choice: 3-4
- Fill in the Blanks: 2-3
- Assertion-Reason: 1-2
- 1-Mark: 3-4
- 2-Mark: 3-4
- 3-Mark: 3-4
- 5-Mark: 2-3
- Case-Based: 1-2

**Question deduplication**: Don't test the same concept across same-depth question types. MCQ, fill-in-the-blank, and 1-mark questions all test recall — a concept tested as an MCQ should not reappear as a 1-mark question or fill-in-the-blank. However, a recall question and an analytical question about the same concept ARE fine (they test different cognitive levels). For example: "What is buffer stock?" (MCQ) and "Analyse why buffer stock alone cannot ensure food security" (5-mark) is acceptable.

**Textbook questions**: If the source material contains end-of-chapter questions, include them in this section with complete model answers. These frequently appear on CBSE exams. Adapt the textbook question into the appropriate question type sub-section.

**Higher-order thinking**: Include at least 3 questions that require analysis, evaluation, or application beyond recall — questions where the student must compare, evaluate, apply to an unfamiliar scenario, or explain *why* something happens. Do not label these as "HOTS" — just ensure they're present in the question mix.

**No markers in Q&A**: Do not use ⭐ or △ in this section. Markers are for Core Content scanning only.

**Difficulty mix**: Roughly 30% recall (1-mark, fill-in, MCQ), 40% application/understanding (2-mark, 3-mark), 30% analysis/evaluation (5-mark, case-based, analytical questions).

**Model answer formats**: Must follow the exact format specified in `exam-patterns-general.md` for each mark category. For Math: show complete step-by-step working. For History: include dates, names, and places. For English/Hindi: include extract-based questions and grammar exercises. For Science: include labeled diagram descriptions and numerical problems.

**Cover all topics**: Distribute questions across all Core Content sub-sections. Don't cluster 10 questions on one topic while ignoring another.

**Vary question types**: Define, explain, compare, contrast, analyze, evaluate, describe, give reasons, prove (Math), draw and label (Science), write in format (Language).

**Include previously asked questions**: If you know certain questions are CBSE favourites for this chapter, include them.

---

## Quality Checks

Apply these checks to every section before considering the notes complete. These are not optional — they represent the minimum quality bar.

### Language & Accessibility
- [ ] Every sentence is understandable by a 14-15 year old without external references
- [ ] No paragraph exceeds 5 sentences
- [ ] No jargon used without immediate definition
- [ ] Active voice preferred over passive voice
- [ ] Sentences are concise — no unnecessary words

### Formatting & Structure
- [ ] Every key term is **bolded** on first use in the Core Content
- [ ] Tables used for any comparison involving 3+ items
- [ ] Consistent heading hierarchy (H1 for title, H2 for sections, H3 for sub-sections)
- [ ] Horizontal rules (---) separate major sections
- [ ] Code blocks used for formulas, code, and structured data
- [ ] Core Content uses H3/H4 headings for labeled parts — no undifferentiated paragraphs

### Content Quality
- [ ] At least 2 real-world examples per major concept
- [ ] Frequently tested concepts marked with ⭐ in Core Content
- [ ] Rarely tested (but important) concepts marked with △ in Core Content
- [ ] No factual errors — every fact cross-checked against source material
- [ ] Source material coverage is complete — no major topic from the source is missing
- [ ] Core Content follows the source material's topic sequence
- [ ] Explanation style matches the topic type (not forced into a fixed template)
- [ ] Core Content has substantive explanations for every major topic (not just brief mentions)

### Exam Alignment
- [ ] Model answers follow CBSE format from `exam-patterns-general.md`
- [ ] 1-mark, 2-mark, 3-mark, and 5-mark questions all present with proper format
- [ ] At least 70% of questions are competency-based (application/analysis/evaluation), not recall
- [ ] Case-based/source-based question included (with passage + multi-part answers)
- [ ] Assertion-reason question included
- [ ] Answer-writing tips from `exam-patterns-general.md` are embedded in Section 6 (Quick Revision)
- [ ] At least 3 questions require analysis/evaluation (not recall)

### Completeness
- [ ] All 7 mandatory sections are present
- [ ] Total word count is within target range (check the per-subject file for subject-specific range)
- [ ] Key Terms section covers all important terms from the source material
- [ ] Quick Revision Table in Section 6 covers every Core Content sub-section
- [ ] Questions and Answers section has 22+ questions, ALL with inline answers
- [ ] No concept tested across multiple same-depth question types (MCQ/fill-in/1-mark)
- [ ] Textbook end-of-chapter questions from source are included with model answers
- [ ] Questions cover all mark types (1, 2, 3, 5 marks) and all major topics in the chapter
- [ ] Section 1 is between 200-300 words

### Pedagogical Quality
- [ ] Content builds progressively from simple to complex within each sub-section
- [ ] Common mistakes draw from the per-subject file's pain points first
- [ ] Concept connections name specific chapters, not just subjects
- [ ] Each Core Content sub-section has a "Think About It" box
- [ ] Worked examples (Math/Science) include a "Why this approach?" sentence
