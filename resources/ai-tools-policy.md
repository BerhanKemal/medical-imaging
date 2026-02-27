# AI Tools Policy — Mobile Apps for Healthcare

**Course:** Mobile Apps for Healthcare
**Program:** Biomedical Engineering, 3rd Year
**Effective from:** Week 4 of the semester

---

## 1. Weeks 1-3: No AI Tools

During the first three weeks of this course, **the use of AI coding assistants (GitHub Copilot, ChatGPT, Claude, Gemini, Cursor, or similar tools) is not permitted** for any course-related coding work.

### Rationale

The opening weeks focus on terminal commands, Git workflows, and Dart fundamentals. These are foundational skills that require **muscle memory** — the kind of deep familiarity that only comes from typing commands yourself, making mistakes, and debugging them manually.

Research in computing education consistently shows that students who rely on AI tools before building foundational competence develop a fragile understanding: they can produce code but cannot debug, modify, or explain it when something goes wrong. In a healthcare context, where software errors can have real consequences for patients, this fragile understanding is especially dangerous.

By the end of Week 3, you will have:
- Internalized core Git commands and workflows through repetition.
- Written Dart code from scratch, building familiarity with the language's syntax and type system.
- Developed the debugging instincts that come from solving problems unaided.

These skills form the foundation on which AI tools become genuinely useful rather than a crutch.

---

## 2. Weeks 4-14: Guided AI Usage

Starting in Week 4, you **may** use AI coding assistants, subject to the following four rules. These rules apply to all course work: labs, sprint work, and the final project.

### Rule 1: The Explain Rule

> **Before you accept any AI-generated code, ask the AI to explain it. If you cannot understand the explanation, do not use the code.**

This is the single most important rule. AI tools can generate syntactically correct code that is semantically wrong, insecure, or inappropriate for your context. You are responsible for every line of code in your project.

**In practice:**
- After receiving a code suggestion, prompt the AI: _"Explain this code line by line."_
- Verify that the explanation matches your understanding of the problem.
- If the code uses a pattern or library you have not encountered, research it independently before accepting.

---

### Rule 2: The Teammate Rule

> **Any teammate may ask "Why did you write it this way?" during code review. "The AI wrote it" is not an acceptable answer.**

If you cannot defend a piece of code during a pull request review or sprint review, it signals that you do not understand your own codebase. This is a problem for you (you cannot debug it), for your team (they cannot maintain it), and for your grade.

**In practice:**
- Before submitting a PR, make sure you can explain every function, widget, and data flow in your changes.
- During code reviews, ask genuine questions — do not just approve.
- If a reviewer asks about a section and you realize you do not understand it, refactor it until you do.

---

### Rule 3: The Attribution Rule

> **When AI tools contribute significantly to a piece of code, note this in the pull request description.**

This is not about punishment — it is about transparency and intellectual honesty. Knowing which parts of the codebase were AI-assisted helps the team understand where deeper review may be needed.

**In practice:**
- In your PR description, include a brief note such as: _"Used Claude to help generate the API service layer. Reviewed and modified the error handling logic."_
- You do not need to attribute every auto-complete suggestion — use your judgment. The threshold is: if you would not have written this code without the AI, attribute it.

---

### Rule 4: The Learning Rule

> **Use AI to learn faster, not to skip learning.**

There is a critical difference between using AI as a tutor and using AI as a shortcut. The goal of this course is for **you** to become a competent mobile developer with awareness of health-tech considerations. AI should accelerate that journey, not bypass it.

**Good usage — AI as a tutor:**
- _"Explain the difference between `StatefulWidget` and `StatelessWidget` with an example."_
- _"I wrote this function but it throws a null error. Help me understand why."_
- _"What is the recommended way to handle authentication tokens in Flutter?"_

**Bad usage — AI as a shortcut:**
- _"Write a complete login screen with Firebase authentication."_
- _"Generate the entire state management layer for my app."_
- _"Write my sprint retrospective."_

---

## 3. Examples

### Good AI Usage

1. **Debugging assistance.** You write a function to parse JSON from a health data API. It throws a type error. You paste the error and your code into an AI tool and ask it to help you understand the type mismatch. You fix the code yourself based on the explanation.

2. **Learning a new concept.** You need to implement local data persistence but have not used Hive before. You ask the AI to explain how Hive works in Flutter, review the explanation, then write the implementation yourself, referring back to the AI's explanation when you get stuck.

3. **Code review preparation.** Before submitting a PR, you ask the AI to review your code for common Flutter anti-patterns. It flags that you are calling `setState` after an async gap without checking `mounted`. You research the issue, understand why it matters, and fix it.

4. **Boilerplate reduction.** You understand how model classes work in Dart and ask the AI to generate `fromJson` and `toJson` methods for a data class you have already designed. You review the output and verify it matches your schema.

### Bad AI Usage

1. **Wholesale feature generation.** You prompt: _"Build me a complete patient dashboard with charts, data fetching, and navigation."_ You paste the result into your project without reading it carefully. During the sprint review, you cannot explain how the chart library works.

2. **Skipping understanding.** You ask the AI to write your entire state management layer using Riverpod. You have never used Riverpod and do not understand providers, but the code compiles, so you ship it. A teammate later asks why you chose `StateNotifierProvider` over `FutureProvider`, and you cannot answer.

3. **Fabricating process artifacts.** You ask the AI to write your sprint retrospective or peer evaluation. These artifacts are meant to capture your genuine experience and reflection — generating them defeats their purpose entirely.

4. **Ignoring the Explain Rule.** The AI suggests using `compute()` for background isolate processing. You do not know what an isolate is, but the code works, so you merge it. Two weeks later, a teammate introduces a bug in that code and nobody on the team can debug it.

---

## 4. Consequences of Violation

This policy operates on a **two-step** consequence model:

### First violation: Written warning

- The instructor will have a private conversation with the student.
- The specific violation will be documented.
- The student will be asked to demonstrate understanding of the flagged code or artifact.
- No grade penalty is applied, but the incident is recorded.

### Second and subsequent violations: Grade reduction

- A deduction of **up to 10 percentage points** will be applied to the relevant assignment (sprint review, final presentation, or peer evaluation component).
- In severe cases (e.g., an entire feature was AI-generated and the student cannot explain any of it), the affected sprint review or project component may receive a **zero**.
- The instructor reserves the right to conduct an **oral examination** on any submitted code to verify understanding.

### How violations are detected

- During sprint reviews and the final presentation, the instructor and TAs will ask targeted questions about code decisions and implementation details.
- Pull request history and commit patterns are reviewed. Sudden large commits of sophisticated code from a student who previously contributed simpler work may be flagged.
- Peer evaluations may surface concerns about a teammate's understanding of their own contributions.

---

## Closing Note: Why This Policy Exists

A growing body of research in computing education suggests that premature reliance on AI tools can create an **AI comfort trap**: students feel productive because they are generating code quickly, but they are not building the mental models needed to solve novel problems, debug unfamiliar errors, or make architectural decisions.

In a healthcare context, the stakes are higher. Mobile health applications handle sensitive patient data, may influence clinical decisions, and operate under regulatory frameworks that demand developers understand what their software does and why. A developer who cannot explain their own code is a liability in any domain — in health technology, they are a risk.

This policy is not anti-AI. It is pro-learning. AI tools are powerful and will be part of your professional toolkit. The goal is to ensure that when you use them, you are **directing** the tool rather than being **directed by** it. The difference is understanding — and understanding is what this course is designed to build.

---

_If you have questions about whether a specific use of AI tools is appropriate, ask the instructor before proceeding. When in doubt, err on the side of doing the work yourself._
