# Week 5 Lab: Sprint Planning Workshop

## Overview

This lab is different from previous weeks — it's a **workshop** where you transition from individual learners to a **development team**. By the end of this session, your team will have a fully set up project infrastructure and a plan for Sprint 1.

> **Project proposals are due at the end of this session.** Use the template at `templates/project-proposal/PROPOSAL_TEMPLATE.md`.

---

## Part 1: Repository Setup (~20 min)

### 1.1 Create Your Team Repository

One team member creates the repository:

```bash
# On GitHub: click "New repository"
# Name: something descriptive (e.g., "mhealth-diabetes-tracker")
# Visibility: Public (so the teacher can see it)
# Initialize with README: Yes
# Add .gitignore: Select "Flutter" from the dropdown
```

### 1.2 Add Team Members as Collaborators

```
GitHub repo → Settings → Collaborators → Add people
```

Add all team members with "Write" access.

### 1.3 Set Up Branch Protection Rules

This is **critical** — it enforces the PR workflow:

```
GitHub repo → Settings → Branches → Add branch protection rule
```

Configure:
- **Branch name pattern:** `main`
- **Require a pull request before merging:** ✅
- **Require approvals:** 1
- **Do not allow bypassing the above settings:** ✅ (even admins must use PRs)

This means **nobody can push directly to `main`**. All changes go through Pull Requests.

### 1.4 Everyone Clones the Repo

```bash
git clone git@github.com:your-team/your-repo.git
cd your-repo
```

Verify the setup:
```bash
git remote -v
git branch -a
```

---

## Part 2: GitHub Projects Board (~15 min)

### 2.1 Create a Project Board

```
GitHub repo → Projects → New project → Board
```

Create these columns:
1. **Backlog** — all planned work
2. **Sprint Backlog** — work selected for current sprint
3. **In Progress** — actively being worked on
4. **In Review** — PR submitted, waiting for review
5. **Done** — merged to main

### 2.2 Understanding the Board

- Each card on the board is a **GitHub Issue**
- Cards move left to right as work progresses
- At any time, each team member should have at most **1-2 cards** in "In Progress"
- A card moves to "In Review" when a PR is opened
- A card moves to "Done" when the PR is merged

---

## Part 3: Writing User Stories (~25 min)

### 3.1 What is a User Story?

A user story describes a feature from the user's perspective:

```
As a [type of user],
I want to [do something],
so that [I get some benefit].
```

**Examples for a mood tracker:**
- "As a patient, I want to log my mood with a score so that I can track how I feel over time."
- "As a patient, I want to see a history of my mood entries so that I can identify patterns."
- "As a clinician, I want to view a patient's mood trends so that I can adjust treatment."

### 3.2 Create GitHub Issues

For each user story, create a GitHub Issue:

```
Title: [Short description]
Body:
  **User Story:**
  As a [user], I want to [action] so that [benefit].

  **Acceptance Criteria:**
  - [ ] Criterion 1
  - [ ] Criterion 2
  - [ ] Criterion 3

  **Estimate:** S / M / L
```

**Story Point Estimates:**
| Size | Meaning | Example |
|------|---------|---------|
| **S** (Small) | Less than 2 hours of work | Add a text field to a form |
| **M** (Medium) | 2-4 hours of work | Build a complete screen with navigation |
| **L** (Large) | 4-8 hours of work | Implement API connection with error handling |

> If something is **XL** (more than 8 hours), break it into smaller stories!

### 3.3 Exercise: Write Your Stories

As a team, write **at least 10-15 user stories** covering:
- Core features of your app
- Authentication (login/register)
- Navigation between screens
- Data entry and display
- Any mHealth-specific features

Add all stories as GitHub Issues. Add them to your Project Board in the **Backlog** column.

### 3.4 Add Labels

Create and apply labels to categorize your issues:
- `feature` — new functionality
- `bug` — something broken (you'll use this later!)
- `ui` — visual/interface work
- `backend` — API/data related
- `auth` — authentication related
- `documentation` — docs and README

---

## Part 4: Sprint 1 Planning (~20 min)

### 4.1 Select Sprint 1 Work

Sprint 1 covers **weeks 5-7** (about 3 weeks of work). Each team member can realistically complete **2-4 medium stories** in a sprint.

As a team, select stories for Sprint 1. Focus on:
1. **App skeleton** — basic navigation between 2-3 screens
2. **Core screen UI** — the main screen of your app
3. **Basic data model** — classes/models for your data

Move selected issues from **Backlog** to **Sprint Backlog**.

### 4.2 Assign Work

- Assign each issue to a team member
- No one should have more than 2 issues assigned at a time
- Start with the most important stories

### 4.3 Sprint Goal

Write a 1-sentence sprint goal as a pinned issue:

> **Sprint 1 Goal:** "Build the app skeleton with navigation between the home, entry, and history screens, with basic mood/health data entry working locally."

---

## Part 5: Flutter Project Setup (~30 min)

### 5.1 Create the Flutter Project

One team member creates the project (on a feature branch!):

```bash
git checkout -b setup/flutter-project
flutter create --org com.yourteam your_app_name
cd your_app_name
```

### 5.2 Clean Up the Default App

Replace the default counter app with a minimal skeleton:

**`lib/main.dart`:**
```dart
import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Your App Name',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
```

**`lib/screens/home_screen.dart`:**
```dart
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: const Center(
        child: Text('Welcome to Your App!'),
      ),
    );
  }
}
```

### 5.3 Create Additional Screen Stubs

Create placeholder screens for your app (at least 2-3):

```
lib/
├── main.dart
├── screens/
│   ├── home_screen.dart
│   ├── entry_screen.dart      # Where users enter data
│   └── history_screen.dart    # Where users view past entries
└── models/
    └── (to be added later)
```

### 5.4 Add Basic Navigation

Add navigation between screens using simple `Navigator.push`:

```dart
ElevatedButton(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const EntryScreen()),
    );
  },
  child: const Text('New Entry'),
),
```

### 5.5 Commit and Create PR

```bash
git add .
git commit -m "Set up Flutter project with basic navigation"
git push -u origin setup/flutter-project
```

Create a PR on GitHub. Have a teammate review and merge it.

Then everyone pulls:
```bash
git checkout main
git pull
```

---

## Checklist Before Leaving

- [ ] Repository created with branch protection enabled
- [ ] All team members can clone and push (to branches)
- [ ] GitHub Project board set up with correct columns
- [ ] At least 10 user stories written as GitHub Issues
- [ ] Sprint 1 planned: stories selected, assigned, sprint goal written
- [ ] Flutter project skeleton committed and merged to main
- [ ] **Project proposal submitted** (link to `templates/project-proposal/PROPOSAL_TEMPLATE.md`)

---

## Tips for Good Sprint Planning

1. **Be realistic** — it's better to finish fewer stories well than to leave many half-done
2. **Start with the skeleton** — navigation and basic screens first, features later
3. **Communicate daily** — even a quick message in your team chat about what you're working on
4. **Use the board** — move cards as you work, it helps the whole team see progress
5. **Ask for help early** — if you're stuck for more than 30 minutes, ask a teammate or the teacher
