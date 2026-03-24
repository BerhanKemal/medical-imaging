# Multiplatform Mobile Software Engineering in Practice

**AGH University of Krakow**

A 14-week project-based course combining multiplatform mobile development (Flutter), backend APIs (FastAPI), and industry-aware software engineering practices. Students build real mobile apps in teams while learning professional development workflows. Mobile health (mHealth) serves as a recurring case study for understanding regulatory requirements in the industry.

## Course Structure

| Week | Topic | Lab Focus | Lecture Focus |
|------|-------|-----------|---------------|
| 1 | Terminal, Git & Developer Mindset | Terminal basics, git init/add/commit, GitHub SSH setup | Why version control, how teams work, course overview |
| 2 | Git Branching, APIs & curl | Branching, merge conflicts, PRs, FastAPI basics, curl | HTTP deep dive, REST architecture, API design |
| 3 | Dart Language Fundamentals | Dart exercises: types, null safety, OOP, async | Mobile dev landscape, Flutter/Dart rationale |
| 4 | Flutter Fundamentals + Teams | First Flutter app, widgets, StatelessWidget/StatefulWidget | Widget lifecycle, state basics, project kickoff |
| 5 | Layouts, Forms & Sprint Planning | Sprint planning workshop, GitHub Projects, user stories | Layouts, forms, Material Design, industry regulatory context |
| 6 | State Management | Project work — core screens | Provider/Riverpod, navigation, user-centered design |
| 7 | Local Data + Sprint Review #1 | Sprint Review #1, retrospective, Sprint 2 planning | SharedPreferences, SQLite, offline-first, sensitive data handling |
| 8 | Networking & API Integration | Project work — API connection | HTTP in Flutter, JSON serialization, GDPR |
| 9 | Authentication & Security | Project work — auth flow | JWT, OAuth2, secure storage, HIPAA/GDPR |
| 10 | Testing + Sprint Review #2 | Sprint Review #2, testing workshop | Testing pyramid, CI, IEC 62304 intro |
| 11 | Advanced Flutter & Polish | Project work — polish and animations | Animations, performance, pub.dev, real-world case studies |
| 12 | Deployment & Regulations | Project work — final features, peer code review | App stores, CI/CD, MDR/FDA medical device regulations |
| 13 | Final Sprint Review & Polish | Sprint Review #3, final polish, presentation prep | Technical debt, open source, career paths, industry trends |
| 14 | Presentations | Final project presentations (15-20 min each) | Course wrap-up, reflection, celebration |

> **Note:** Lab always precedes the lecture in a given week — creating a "struggle first, understand later" pedagogical flow.

## Assessment

| Component | Weight | Details |
|-----------|--------|---------|
| Individual foundations (weeks 1-3) | 15% | 3 GitHub assignments: git, API, Dart skills |
| Sprint reviews (3x) | 25% | Progress, demo quality, teamwork, process |
| Final project + presentation | 50% | Working app, code quality, architecture, UX, presentation |
| Peer evaluation | 10% | Individual contribution assessed by teammates |

## Sprint Schedule

| Sprint | Weeks | Focus | Ceremony |
|--------|-------|-------|----------|
| Sprint 1 | 6–7 | Core screens, navigation, basic state | Review at Week 7 |
| Sprint 2 | 8–10 | API integration, auth, data persistence | Review at Week 10 |
| Sprint 3 | 11–13 | Polish, testing, advanced features | Review at Week 13 |
| — | 14 | Final presentations | Final demo |

## Lecture Demo Project: Mood Tracker

The teacher builds a mood tracker app live during lectures, one feature per week:

| Week | Demo Adds... |
|------|-------------|
| 4 | Main screen, basic widget tree |
| 5 | Form UI with validation, layout |
| 6 | State management with Riverpod |
| 7 | Local storage (SQLite) |
| 8 | API connection to FastAPI backend |
| 9 | Login/register with JWT auth |
| 10 | Unit tests and widget tests |
| 11 | Animations and UI polish |
| 12 | Release build overview |

Students always have a working reference implementation to study.

## Technologies

- **Frontend:** Flutter (Dart)
- **Backend:** FastAPI (Python)
- **Version Control:** Git (console only) + GitHub
- **API Testing:** curl
- **Database:** SQLite (both backend and local mobile storage)

## AI Tools Policy

- **Weeks 1-3:** No AI tools. Build muscle memory for terminal, git, and Dart.
- **Weeks 4-14:** Guided AI usage with four rules:
  1. **The Explain Rule** — understand before accepting
  2. **The Teammate Rule** — you must be able to explain any code you wrote
  3. **The Attribution Rule** — note AI-assisted code in PR descriptions
  4. **The Learning Rule** — use AI to learn faster, not skip learning

Full policy: [`resources/ai-tools-policy.md`](resources/ai-tools-policy.md)

## Project Requirements

Student teams (3-4 people) build a mobile app. Minimum requirements:

- A clearly defined problem with identified target users
- At least 3 screens
- API connection (own FastAPI or provided endpoint)
- Some form of authentication
- Git workflow with PRs (no direct push to main)
- 1-page proposal submitted by Week 5
- Awareness of relevant industry regulations (e.g., GDPR for data privacy; mHealth regulations like MDR/FDA if the app handles health data)

Proposal template: `templates/project-proposal/PROPOSAL_TEMPLATE.md` (in the course materials repository)

## Repository Structure

```
.
├── README.md                          # This file
├── week-01-terminal-git/
│   └── lab/                           # Terminal & git exercises
├── week-02-git-apis-curl/
│   ├── lab/                           # Branching, PRs, curl exercises
│   └── fastapi-starter/               # Starter FastAPI template
├── week-03-dart-fundamentals/
│   └── lab/                           # Dart exercises + CLI mood logger
├── week-04-flutter-fundamentals/
│   └── lab/                           # Flutter widget exercises
├── week-05-layouts-forms-sprints/
│   └── lab/                           # Sprint planning workshop
├── week-06-state-management/          # Lab (Riverpod) + starter project + lecture
├── week-07-local-data/                # Lab (SQLite) + starter project + lecture
├── week-08-networking-api/            # Lab (HTTP/API) + starter project + lecture
├── week-09-authentication/            # Lab (JWT/auth) + starter project + lecture
├── week-10-testing-quality/           # (coming soon)
├── week-11-advanced-flutter/          # (coming soon)
├── week-12-deployment-regulations/    # (coming soon)
├── week-13-final-sprint/              # (coming soon)
├── week-14-presentations/             # (coming soon)
├── mood-tracker-api/                  # Complete FastAPI backend (reference)
├── templates/
│   ├── project-proposal/              # 1-page proposal template
│   ├── rubrics/                       # Sprint review & final presentation rubrics
│   └── forms/                         # Peer evaluation form
└── resources/
    ├── ai-tools-policy.md             # AI tools policy handout
    ├── ACCESSIBILITY_GUIDE.md         # Accessibility quick reference for Flutter
    ├── MHEALTH_REGULATIONS.md         # Industry regulations reference (GDPR, HIPAA, MDR examples)
    └── PROJECT_GRADING.md             # Grading rubrics and timeline
```

## Grading & Resources

- **Full grading guide:** [`resources/PROJECT_GRADING.md`](resources/PROJECT_GRADING.md) — rubrics, timeline, and grade descriptors
- **Accessibility guide:** [`resources/ACCESSIBILITY_GUIDE.md`](resources/ACCESSIBILITY_GUIDE.md) — Flutter accessibility quick reference
- **Industry regulations reference:** [`resources/MHEALTH_REGULATIONS.md`](resources/MHEALTH_REGULATIONS.md) — GDPR, HIPAA, MDR — regulatory case studies
- Sprint review rubric: `templates/rubrics/sprint-review-rubric.md` (in the course materials repository)
- Final presentation rubric: `templates/rubrics/final-presentation-rubric.md` (in the course materials repository)
- Peer evaluation form: `templates/forms/peer-evaluation.md` (in the course materials repository)

## Prerequisites

Students should have:
- Basic programming experience (Python, C/C++, or similar)
- A laptop capable of running Flutter (macOS, Windows, or Linux)
- Willingness to learn new tools and workflows

No prior experience with git, terminal, or mobile development is expected.
