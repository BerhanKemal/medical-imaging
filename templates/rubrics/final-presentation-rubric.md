# Final Project Presentation Rubric — Multiplatform Mobile Software Engineering in Practice

> **Weight:** The final presentation accounts for **50% of the total course grade.**
> Scored out of **100 points**.

---

## Purpose

The final presentation is your opportunity to demonstrate what you've learned — not just the app you built, but how you built it, why you made the decisions you made, and what you'd do differently. This mirrors how real teams present their work to stakeholders.

## Task

Your team delivers a 15-minute presentation:

- **10 minutes:** present the problem, show the app (live demo), explain key technical decisions, discuss industry and regulatory considerations
- **5 minutes:** Q&A from the instructor and peers

Before the presentation, ensure your GitHub repository is clean: README updated, no hardcoded secrets, meaningful commit history visible.

---

## Minimum Specification

!!! warning "Pass/Fail Gate"
    To be eligible for grading, the project must meet **ALL** of these:

    - App launches on a device/emulator without crashing
    - At least 3 distinct screens implemented
    - Backend API connection functional
    - Authentication flow present
    - Git history shows PR-based workflow
    - All team members present (or excused in advance)

    Projects that do not meet these minimums receive a maximum of **40/100**.

---

## Evaluation Criteria

### 1. Functionality — 20 points

The app works, solves the stated problem, and handles errors gracefully.

| Score | Descriptor |
|-------|------------|
| 18-20 | App fully addresses the problem stated in the proposal. All core features work reliably. Edge cases and errors are handled gracefully with informative user feedback. |
| 14-17 | App addresses the core problem. Most features work. Error handling is present but incomplete in some areas. |
| 10-13 | App partially addresses the problem. Some features are incomplete or buggy. Basic error handling exists. |
| 6-9   | App has significant bugs or missing features. Error handling is minimal; crashes may occur. |
| 0-5   | App does not run or fails to address the stated problem in any meaningful way. |

---

### 2. Code Quality — 15 points

Clean, readable code with proper git history (meaningful commits, pull requests, branches) and no hardcoded secrets.

| Score | Descriptor |
|-------|------------|
| 14-15 | Code is clean, well-organized, and follows Dart/Flutter conventions. Git history shows meaningful commits, consistent use of branches and PRs with reviews. No hardcoded API keys, passwords, or secrets anywhere in the repository history. |
| 11-13 | Code is generally clean with minor style inconsistencies. Git history is mostly well-structured. No secrets in the current codebase (minor historical issues acceptable if addressed). |
| 8-10  | Code has readability issues (e.g., poor naming, large functions). Git history is messy — large monolithic commits, minimal PR usage. |
| 4-7   | Code is difficult to follow. Little evidence of code review. Hardcoded secrets found in the repository. |
| 0-3   | Code is chaotic with no consistent structure. No meaningful git workflow used. |

---

### 3. Architecture — 15 points

Separation of concerns, reasonable project structure, and appropriate state management.

| Score | Descriptor |
|-------|------------|
| 14-15 | Clear separation between UI, business logic, and data layers. Project structure is logical and easy to navigate. State management solution is appropriate and consistently applied. |
| 11-13 | Reasonable separation of concerns with minor violations. Project structure is mostly logical. State management is used but with some inconsistencies. |
| 8-10  | Some attempt at structure, but business logic is mixed into UI widgets. State management is ad-hoc or inconsistent. |
| 4-7   | Minimal separation of concerns. Most logic resides in widget files. No clear project structure. |
| 0-3   | No discernible architecture. All code in a few monolithic files. |

---

### 4. Industry & Regulatory Awareness — 15 points

Data privacy is considered, the app is appropriate for target users, and accessibility has been addressed.

| Score | Descriptor |
|-------|------------|
| 14-15 | Team demonstrates strong awareness of relevant regulations (e.g., GDPR for data privacy, domain-specific frameworks where applicable). App is designed with the target user group in mind. Accessibility features implemented (e.g., screen reader support, sufficient contrast, scalable text). Relevant regulations identified and discussed. |
| 11-13 | Privacy considerations are present (e.g., no plaintext storage of sensitive data). Some accessibility features implemented. Basic regulatory awareness demonstrated. |
| 8-10  | Privacy is mentioned but not fully addressed in the implementation. Accessibility is minimal. Regulatory context is vague. |
| 4-7   | Little evidence of privacy or accessibility considerations. No regulatory awareness demonstrated. |
| 0-3   | User data handled carelessly. No consideration of the target user population, accessibility, or regulations. |

---

### 5. Presentation Quality — 15 points

Clear communication, a working live demo, and all team members present and participating.

| Score | Descriptor |
|-------|------------|
| 14-15 | All team members present and contribute meaningfully to the presentation. Communication is clear and well-paced. Live demo runs smoothly and effectively showcases the app. Slides (if used) are clean and support the narrative. |
| 11-13 | All members present; most contribute. Communication is clear. Demo works with minor hiccups. |
| 8-10  | Some members contribute minimally. Presentation is disorganized or hard to follow. Demo has notable issues. |
| 4-7   | One or more members absent without justification. Presentation is unclear. Demo fails or is skipped. |
| 0-3   | Team is largely unprepared. No demo. Poor communication throughout. |

---

### 6. User Experience — 10 points

Intuitive UI, consistent design language, and proper handling of loading and error states.

| Score | Descriptor |
|-------|------------|
| 9-10  | UI is intuitive and requires no explanation. Design is visually consistent (colors, typography, spacing). Loading indicators, empty states, and error messages are present and helpful. Navigation is logical. |
| 7-8   | UI is generally intuitive. Design is mostly consistent. Loading and error states exist for core flows. |
| 5-6   | UI works but is not intuitive — users may need guidance. Design inconsistencies are noticeable. Some loading/error states missing. |
| 3-4   | UI is confusing. No consistent design language. Loading and error states largely absent. |
| 0-2   | UI is unusable or severely broken. No attention to design or user feedback. |

---

### 7. Reflection & Learning — 10 points

Honest assessment of what went well, what went poorly, and what the team would do differently.

| Score | Descriptor |
|-------|------------|
| 9-10  | Team provides a candid, thoughtful reflection. Clearly articulates lessons learned — both technical and process-related. Identifies specific things they would change with concrete reasoning. |
| 7-8   | Reasonable reflection with some genuine insights. Lessons learned are mentioned but could be more specific. |
| 5-6   | Reflection is superficial or generic (e.g., "we should have started earlier"). Limited evidence of deep learning. |
| 3-4   | Minimal reflection. Team struggles to articulate what they learned. |
| 0-2   | No reflection provided or team claims everything was perfect with no room for improvement. |

---

## Grading Scale

| Grade | Score Range | Description |
|-------|------------|-------------|
| **Excellent** | 90 -- 100 | Outstanding project that demonstrates mastery of mobile development, industry and regulatory awareness, and professional teamwork. |
| **Good** | 75 -- 89 | Strong project with solid technical execution and good awareness of regulatory considerations. Minor areas for improvement. |
| **Satisfactory** | 60 -- 74 | Acceptable project that meets minimum requirements but has notable gaps in quality, process, or regulatory awareness. |
| **Needs Improvement** | < 60 | Project has significant deficiencies. Core requirements are not met or quality is well below expectations. |

---

## Notes for Evaluators

- Each team has **15 minutes** for the final presentation: approximately 10 minutes for the presentation and demo, and 5 minutes for Q&A.
- Review the team's GitHub repository, commit history, and project board **before** the session.
- Both the **product** (what they built) and the **process** (how they built it) matter.
- If a team member is absent without prior arrangement, deduct up to 5 points from Presentation Quality and flag for individual grade adjustment.
- Cross-reference with peer evaluations when assigning individual grades.
