# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Purpose

This project develops a **Claude Code skill (`cbse-notes-creator`)** that automatically generates comprehensive, exam-aligned study notes for **CBSE Class 9 students (ages 14-15)** from any source material. The skill covers 10 subjects: Mathematics, Science (Physics/Chemistry/Biology), History, Geography, Economics, Political Science, Computer Science, English, and Hindi.

The skill produces 10-section structured notes with subject-specific adaptations (5 variants: Narrative, Formula, Process/Classification, Language, Applied), self-assessment quizzes, model exam answers, mnemonics, and an extensive practice question bank — all with complete ideal answers.

## Directory Structure

```
cbse-notes-creator/          # The skill itself
├── SKILL.md                 # Main orchestration (workflow steps for the AI to follow)
└── references/              # Reference files loaded by the skill at runtime
    ├── exam-patterns.md     # CBSE exam structure, marking schemes, model answer formats
    ├── subject-profiles.md  # Per-subject adaptation rules, formatting, pain points
    └── note-structure-template.md  # 10-section template, 5 variants, quality checks

docs/                        # French Revolution example materials (reference implementation)
├── French_Revolution_Notes_v2.md  # Example output — study notes (the quality benchmark)
├── keyConcepts.md           # Simplified key concepts version
├── iess301-theFrenchRevolution.pdf  # Original NCERT PDF source
└── theFrenchRevolution.md   # Source converted to markdown

evals/samples/               # Sample NCERT chapter PDFs for testing across subjects
├── samplechapter-maths.pdf        # Introduction to Euclid's Geometry
├── samplechapter-science.pdf      # The Fundamental Unit of Life (Biology)
├── samplechapter-english.pdf      # The Little Girl (Beehive Ch.3)
├── samplechapter-history.pdf      # French Revolution
├── samplechapter-geography.pdf
├── samplechapter-economics.pdf
└── samplechapter-civics.pdf
```

## How the Skill Works

1. The AI reads the 3 reference files from `cbse-notes-creator/references/`
2. User provides: source material (PDF/markdown/pasted text), subject, chapter name
3. AI analyzes source, identifies subject variant, extracts core concepts
4. AI presents outline for user approval (with option for section-by-section review)
5. AI generates all 10 sections following the template + subject profile
6. Output saved as `{ChapterName}_Notes.md`

## Key Design Decisions

- **Notes are structured into 10 mandatory sections** (not 9 — Section 10 "Extra Practice Questions with Answers" was added in iteration 2 based on user feedback that more question variations with ideal answers were needed)
- **5 structural variants** adapt the core content section per subject type — don't try to make one format fit all subjects
- **Every question must have a complete ideal answer** — no exceptions
- **Target word counts** vary by subject (Math: 8K-12K, Science: 10K-15K, History: 12K-18K, etc.) — see `subject-profiles.md`
- **Language subjects (English/Hindi)** must include grammar sub-sections even when the source chapter is only prose/poetry, because CBSE exams test grammar alongside literature
- **French_Revolution_Notes_v2.md** in `docs/` is the original reference example but the skill is designed to produce higher quality output (with misconceptions, quizzes, mnemonics, cross-chapter connections, and practice questions that v2 lacks)

## Prompt Document

`CBSE-Class9-Notes-Generation-Prompt.md` contains the original requirements specification that drove the creation of this skill. It describes the pedagogical principles, structural requirements, and quality standards. Refer to it for the "why" behind design decisions.

## Current Status (as of 2026-03-28)

### Completed
- **Skill created and tested** — `cbse-notes-creator/SKILL.md` + 3 reference files are complete and functional
- **2 iterations of testing done** — tested with 3 subjects (Math, Science/Biology, English) using sample PDFs from `evals/samples/`
  - **Iteration 1**: Skill worked structurally (10/10 assertions passed) but word counts were too low (4.5K-6.7K vs targets of 8K-18K) and questions were insufficient
  - **Iteration 2**: Fixed — added Section 10 (Extra Practice Questions), strengthened word count guidance, added grammar requirement for Language variants. Results: all 12/12 assertions passed, word counts in target (Math: 10.2K, Science: 11.1K, English: 10.5K), 28-46 questions per output all with ideal answers
- **Baseline comparison done** — with-skill outputs scored 10-12/12 vs without-skill baselines scoring 1-2/10 on structural assertions
- **Test outputs exist** at `~/.claude/my-plugins/my-skills/skills/cbse-notes-generator/cbse-notes-generator-workspace/` (iteration-1/ and iteration-2/) — these are from before the skill was moved to the project folder

### Next Steps (in order of priority)
1. **Description optimization** — Trigger eval queries (20 queries: 10 should-trigger, 10 should-not-trigger) were drafted and presented to the user in a browser-based review UI but NOT yet finalized or exported. The eval set JSON is at `~/.claude/my-plugins/my-skills/skills/cbse-notes-generator/cbse-notes-generator-workspace/trigger-eval.json`. Run the optimization loop using the skill-creator's `scripts.run_loop` to find the best description for SKILL.md frontmatter.
2. **Test with remaining subjects** — Only 3 of 7 available sample chapters have been tested (Math, Science, English). Geography, Economics, Civics, and History samples in `evals/samples/` have not been tested yet.
3. **Package the skill** — Once description is optimized, package as a `.skill` file for easy distribution/installation.
4. **Consider moving project to a more appropriate root directory** — Currently under `History/01 French Revolution/` which is misleading since the skill is for all subjects. The user may want to reorganize.

### Known Limitations
- Hindi and Computer Science have no sample chapters for testing
- The skill is currently a local project-level skill, not installed globally — it must be invoked by pointing to the SKILL.md path
- PDF reading quality varies — the skill instructs the AI to ask for markdown/text if PDF parsing fails
