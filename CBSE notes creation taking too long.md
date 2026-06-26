# CBSE notes creation taking too long

**Session ID:** ses_2abaacda7ffe638a3Bp4b830j0
**Created:** 4/3/2026, 10:42:42 PM
**Updated:** 4/3/2026, 10:50:34 PM

## Assistant (Build · glm-5.1 · 140.0s)

Good. Now I have the full picture. Let me analyze this properly.

Here's a detailed breakdown of what's happening and what can be done.

## Where Does the Time Go?

### The Context Budget

When the skill runs, here's what gets loaded into the LLM's context window **before a single word of notes is generated**:

| File | Words | Tokens (approx) |
|------|-------|-----------------|
| `SKILL.md` | 2,342 | ~3,000 |
| `universal-template.md` | 3,695 | ~4,700 |
| `exam-patterns-general.md` | 1,785 | ~2,300 |
| One subject file (e.g., biology) | ~1,300 | ~1,700 |
| Source material (a typical NCERT chapter) | ~5,000-8,000 | ~6,500-10,000 |
| **Total context consumed before generation** | | **~18,000-21,700** |

Most LLMs have a 128K-200K context window, so this isn't a hard limit issue. But here's the real problem:

**Every single generation call re-reads all of this context.** The model has to process ~20K tokens of instructions + source material, synthesize it all, and then produce 8K-13K tokens of output. That's the core bottleneck. It's not one slow thing — it's the sheer volume of what the model must hold in working memory while writing.

### The Sequential Generation Problem

The skill generates notes **sequentially** in one massive pass. All 7 sections, 22+ questions with full answers, 6K-10K words. The model can't start writing Section 7 (Questions) until it's "thought through" Sections 1-6, because questions must cover all core content sub-sections and avoid duplication.

At typical inference speeds of 50-100 tokens/second output, generating 10K-13K tokens of notes takes **2-4 minutes of pure output streaming**. But the "thinking" time between sections — where the model plans what to write next while respecting all the quality checks — adds substantial overhead.

### The Quality Check Tax

The skill has **28+ quality checks** listed across the template. The model doesn't explicitly run these as a separate step, but it's been instructed to verify against them while writing. This adds cognitive load to every paragraph — "Am I within 5 sentences? Did I bold key terms? Is this a comparison of 3+ items needing a table?" Each check is trivial, but 28 checks applied continuously across 10K words is a significant drag.

---

## Solutions

### 1. Parallel Agent Architecture (Biggest Impact)

The single biggest speedup: **split generation across multiple agents working in parallel.**

The 7 sections have a clear dependency graph:

```
Sections 1, 2, 3 can be partially parallelized
Section 4 depends on Section 3 (misconceptions about core content)
Section 5 depends on Section 3 (connections to core content)
Section 6 depends on Sections 1-5 (summary of everything)
Section 7 depends on Section 3 (questions about core content)
```

Here's a concrete architecture:

**Phase 1 — Orchestrator Agent** (runs first, ~30 seconds):
- Loads `SKILL.md` + source material
- Identifies subject, classifies topic types, extracts core concepts
- Creates the coverage checklist
- Writes Section 1 (Chapter Introduction) and Section 2 (Key Terms) — these are short and formulaic
- Produces a **structured brief** for the other agents: the outline, the core concepts, their topic types, the key terms, and any subject-specific instructions

**Phase 2 — Three Agents Run in Parallel** (~3-4 minutes each, but simultaneous):

| Agent | Produces | What it needs |
|-------|----------|---------------|
| **Core Content Agent** | Section 3 (Core Content) | Source material, structured brief, one subject reference file, the relevant section of `universal-template.md` |
| **Misconceptions Agent** | Section 4 (Misconceptions) | Structured brief, source material, subject file's "Common Pain Points" section only |
| **Questions Agent** | Section 7 (Questions & Answers) | Structured brief (which includes the coverage checklist), source material, the exam-patterns file, subject exam patterns section only |

**Phase 3 — Assembly Agent** (runs after Phase 2, ~1 minute):
- Receives outputs from all Phase 2 agents
- Writes Section 5 (Concept Connections) — this is short and formulaic, needs the core content outline
- Writes Section 6 (Quick Revision) — synthesizes everything into revision format
- Assembles all 7 sections into the final file
- Runs quality checks as a final validation pass

**Time savings**: Instead of 10-12 minutes sequential → ~5-6 minutes total (Phase 1: 30s + Phase 2: ~4 min parallel + Phase 3: ~1 min). Roughly **50-60% reduction**.

The key insight: each Phase 2 agent only needs a **subset** of the reference files. The Questions agent doesn't need the full universal template — it only needs the Section 7 spec and the exam patterns file. The Core Content agent doesn't need exam patterns at all.

### 2. Lazy Loading of Reference Files (Moderate Impact)

Currently the skill loads all 3 reference files upfront. But not all are needed at all times:

| Reference File | Actually Needed When |
|----------------|---------------------|
| `universal-template.md` (3,695 words) | Writing Sections 1-6, especially Section 3 |
| `exam-patterns-general.md` (1,785 words) | Only when writing Section 6 (tips) and Section 7 (questions) |
| Subject file (~1,300 words) | Throughout, but different sections at different times |

**The fix**: Split each reference file into **section-specific chunks**. Instead of one monolithic `universal-template.md`, have:

- `references/sections/sec1-introduction.md` (~200 words)
- `references/sections/sec2-key-terms.md` (~250 words)
- `references/sections/sec3-core-content.md` (~2,000 words — the biggest chunk)
- `references/sections/sec4-misconceptions.md` (~300 words)
- `references/sections/sec5-connections.md` (~250 words)
- `references/sections/sec6-quick-revision.md` (~350 words)
- `references/sections/sec7-questions.md` (~800 words)
- `references/sections/quality-checks.md` (~400 words)

Similarly, split each subject file into:
- `topic-types.md` — only needed for Section 3
- `pain-points.md` — only needed for Section 4
- `exam-patterns.md` — only needed for Sections 6-7

Each agent in the parallel architecture loads **only what it needs**. The Core Content agent loads `sec3-core-content.md` + the subject's `topic-types.md`. The Questions agent loads `sec7-questions.md` + `exam-patterns-general.md` + the subject's `exam-patterns.md`.

This cuts the context each agent processes by 40-60%, directly reducing both thinking time and output time.

### 3. Pre-computed Section Scaffolding (Moderate Impact)

Sections 1, 2, 5, and 6 are **formulaic** — they follow templates with fill-in-the-blank structure. The outline step (Step 3 in the current skill) already extracts most of the information needed for these sections.

**The fix**: In Step 3, instead of just creating an outline, also produce a **structured JSON/dict** containing:

```json
{
  "chapter_name": "...",
  "subject": "...",
  "core_concepts": ["concept1", "concept2", ...],
  "key_terms": [{"term": "...", "definition": "...", "example": "..."}],
  "topic_types": {"concept1": "Process/Mechanism", "concept2": "Classification"},
  "sub_section_headings": ["3.1 Why the Revolution Began", "3.2 Impact on Different Groups", ...],
  "prerequisites": ["Concept X from Class 8 Chapter Y"],
  "connections": {"within_subject": [...], "across_subjects": [...]}
}
```

The orchestrator fills in everything it can at analysis time. Then:
- Section 1 is generated by filling a template (not free-form generation)
- Section 2 is generated from the `key_terms` array
- Section 5 is generated from the `connections` object
- Section 6 is generated by summarizing the core content headings

This turns 4 sections from "generate from scratch" into "fill a template + light editing." That's roughly 2,000-3,000 fewer tokens to generate, saving 30-60 seconds.

### 4. Two-Pass Questions (Moderate Impact)

Section 7 (Questions & Answers) is the **single largest section** — often 3,000-4,000 words with 22+ questions and full answers. The model has to:
- Decide which concepts to test at which depth
- Ensure no duplication across same-depth types
- Write complete model answers for every question
- Format everything correctly

**The fix**: Split question generation into two passes:

**Pass 1 — Question Blueprint** (~20 seconds): Generate only the question stems (no answers), organized by type, with a note on which concept each tests. This is fast because it's short output.

```
MCQ Q1: Tests "osmosis definition" (recall)
MCQ Q2: Tests "organelle functions" (recall)
Fill-in Q5: Tests "cell wall composition" (recall)
1-mark Q9: Tests "diffusion vs osmosis distinction" (recall) [DUPLICATE with MCQ Q2 concept? → adjust]
...
```

**Pass 2 — Answer Generation** (~2 minutes): Generate answers for all questions. This can even be parallelized — split 22 questions across 2-3 agents, each answering 7-8 questions.

The blueprint pass catches duplication issues early (the model can see all questions at once) and the answer pass is simpler because each agent only needs the question + source material, not the full reference files.

### 5. Caching Source Analysis (Small-Moderate Impact for Repeated Use)

If you generate notes for multiple chapters of the same subject, the subject file content doesn't change. The current skill re-loads and re-processes it every time.

**The fix**: For the orchestrator pattern, the orchestrator can maintain a "subject profile cache" — a distilled version of the subject file that's only the essential rules for that subject (maybe 200-300 words instead of 1,300). After the first run for a subject, subsequent runs use the cached profile instead of re-reading the full subject file.

### 6. Quality Checks as a Separate Agent (Small Impact, Better Quality)

Instead of having the model run 28 quality checks while writing (which slows down generation), move quality checking to a **separate validation agent** that runs after all sections are assembled. This agent:

- Loads only `quality-checks.md` (~400 words) + the assembled notes
- Runs through each check
- Reports failures with specific locations

This doesn't save much total time, but it produces better results — the writing agent focuses on writing well, and the checking agent focuses on checking rigorously. Separation of concerns.

---

## Summary: Recommended Architecture

```
┌─────────────────────────────────────────────────────────┐
│  ORCHESTRATOR AGENT (Phase 1, ~30s)                      │
│  Loads: SKILL.md + source + subject-file                  │
│  Produces: Outline + structured brief + Sections 1 & 2   │
│  + coverage checklist + key terms JSON                    │
└──────────────────────┬──────────────────────────────────┘
                       │ distributes brief to:
          ┌────────────┼────────────┐
          ▼            ▼            ▼
   ┌──────────────┐ ┌──────────────┐ ┌──────────────┐
   │ CORE CONTENT │ │ MISCONCEPTIONS│ │  QUESTIONS   │
   │ AGENT        │ │ AGENT         │ │  AGENT       │
   │              │ │              │ │              │
   │ Loads:       │ │ Loads:       │ │ Loads:       │
   │ - Brief      │ │ - Brief      │ │ - Brief      │
   │ - sec3 ref   │ │ - sec4 ref   │ │ - sec7 ref   │
   │ - topic-types│ │ - pain-points│ │ - exam-patt  │
   │ - Source      │ │ - Source      │ │ - Source     │
   │              │ │              │ │              │
   │ Produces:    │ │ Produces:    │ │ Produces:    │
   │ Section 3    │ │ Section 4    │ │ Section 7    │
   └──────┬───────┘ └──────┬───────┘ └──────┬───────┘
          │                │                │
          └────────────────┼────────────────┘
                           ▼
              ┌────────────────────────┐
              │ ASSEMBLY AGENT         │
              │ (Phase 3, ~1 min)      │
              │                        │
              │ Produces:              │
              │ - Section 5 (Connect)  │
              │ - Section 6 (Revision) │
              │ - Final assembly       │
              │ - Quality validation   │
              └────────────────────────┘
```

**Expected time**: ~5-6 minutes total (down from 10-12). The biggest win is Phase 2 running in parallel, with lazy loading reducing each agent's context size.

**To implement this**: The SKILL.md would need to be rewritten from a sequential workflow to an orchestrator pattern. The reference files would be split into section-specific chunks. And you'd need a way to invoke sub-agents — which depends on your skill execution environment (if you're using Claude Code skills, the Task tool can launch parallel agents).

Want me to implement any of these changes?

---

