# Week 5 Lab: Sprint Planning Workshop

> **Course:** Mobile Apps for Healthcare
> **Duration:** ~2 hours (workshop format)
> **Prerequisites:** Flutter fundamentals (Week 4), team formation completed

## Overview

This lab is different from previous weeks — it's a **workshop** where you transition from individual learners to a **development team**. By the end of this session, your team will have a sprint plan, user stories, and a clear picture of what you're building.

> **Verbal pitch + written proposal due this week.** Before leaving, your team will pitch your project idea to the instructor in 2 minutes (see checklist at the bottom). The **full written proposal** is also due at the end of this week (Week 5) so that Sprint 1 can begin in Week 6 with an approved scope.

!!! note "Repository and project board already set up"
    You should have completed the **Team Setup homework** from Week 4 (Part 7). If your team hasn't done this yet, do it now — but be aware you're starting behind.

    Verify before proceeding:

    - [ ] Team repository exists on GitHub with branch protection enabled
    - [ ] All team members can clone the repo and push to branches
    - [ ] GitHub Projects board exists with 5 columns (Backlog, Sprint Backlog, In Progress, In Review, Done)

---

## Part 1: Writing User Stories (~25 min)

### 1.1 What is a User Story?

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

### 1.2 Create GitHub Issues

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

### 1.3 Exercise: Write Your Stories

As a team, write **at least 10-15 user stories** covering:
- Core features of your app
- Authentication (login/register)
- Navigation between screens
- Data entry and display
- Any mHealth-specific features

Add all stories as GitHub Issues. Add them to your Project Board in the **Backlog** column.

!!! tip
    Teams can start drafting user stories as homework between Weeks 4-5. Use your team chat to brainstorm before the workshop — you'll move faster in class if you arrive with ideas.

### 1.4 Add Labels

Create and apply labels to categorize your issues:
- `feature` — new functionality
- `bug` — something broken (you'll use this later!)
- `ui` — visual/interface work
- `backend` — API/data related
- `auth` — authentication related
- `documentation` — docs and README

---

## Part 2: Sprint 1 Planning (~20 min)

### 2.1 Select Sprint 1 Work

Sprint 1 covers **weeks 6-7** (about 2 weeks of work). Each team member can realistically complete **2-3 medium stories** in a sprint.

As a team, select stories for Sprint 1. Focus on:
1. **App skeleton** — basic navigation between 2-3 screens
2. **Core screen UI** — the main screen of your app
3. **Basic data model** — classes/models for your data

Move selected issues from **Backlog** to **Sprint Backlog**.

### 2.2 Assign Work

- Assign each issue to a team member
- No one should have more than 2 issues assigned at a time
- Start with the most important stories

### 2.3 Sprint Goal

Write a 1-sentence sprint goal as a pinned issue:

> **Sprint 1 Goal:** "Build the app skeleton with navigation between the home, entry, and history screens, with basic mood/health data entry working locally."

!!! info "Grading"
    For detailed sprint review rubrics and grading criteria, see the [Project Grading Guide](../../resources/PROJECT_GRADING.md).

---

## Part 3: Preview — State Management (~20 min)

!!! info "Why this section exists"
    Next week (Week 6), you'll implement state management with Riverpod. This preview introduces the **vocabulary and concepts** so you arrive prepared. **No coding here** — just understanding.

### 3.1 Why `setState()` Doesn't Scale

In Week 4, you used `setState()` to update the UI. This works for a single screen, but what happens when **multiple screens need the same data**?

Consider a mood tracker app:

```
Home Screen          Add Mood Screen        Stats Screen
┌──────────────┐     ┌──────────────┐     ┌──────────────┐
│ Mood List    │     │ Score: [7]   │     │ Average: 6.2 │
│ - 😊 7/10   │     │ Note: [...]  │     │ Total: 15    │
│ - 😐 5/10   │     │ [Save]       │     │ Highest: 9   │
│ - 😢 3/10   │     │              │     │              │
└──────────────┘     └──────────────┘     └──────────────┘
```

When the user saves a new mood on the Add screen:

- The Home Screen list needs to update
- The Stats Screen averages need to recalculate
- The Add Screen needs to clear the form

With `setState()`, each screen manages its own state independently. To keep them in sync, you'd need to pass callbacks up and down the widget tree — this is called **prop drilling**, and it becomes unmanageable quickly.

### 3.2 The Solution: Centralized State

Instead of each screen holding its own copy of the data, we put the data in a **central place** that all screens can access:

```
                ┌─────────────────────┐
                │   MoodNotifier      │
                │   (central state)   │
                │                     │
                │   moods: [...]      │
                │   addMood()         │
                │   deleteMood()      │
                └──────┬──────────────┘
                       │
          ┌────────────┼────────────┐
          ▼            ▼            ▼
    Home Screen   Add Screen   Stats Screen
    (watches)     (reads)      (watches)
```

When `addMood()` is called, **every screen watching the state automatically updates**. No callbacks, no prop drilling.

### 3.3 Key Vocabulary for Next Week

You'll encounter these terms in Week 6. Don't memorize definitions — just recognize them:

| Term | What It Is | Analogy |
|------|-----------|---------|
| **Provider** | A container that holds a piece of state and makes it accessible to any widget | Like a global variable, but safe and reactive |
| **StateNotifier** | A class that holds state and exposes methods to modify it | Like a controller — it owns the data and the rules for changing it |
| **`ref.watch()`** | Subscribe to a provider — rebuild when it changes | Like a spreadsheet cell that updates when its formula inputs change |
| **`ref.read()`** | Read a provider's value once (in event handlers) | Like checking a value at a specific moment, without subscribing |
| **ProviderScope** | The root widget that stores all provider state | The "container" that makes everything work |

### 3.4 What You'll Build Next Week

In Week 6, you'll take the Mood Tracker starter project and replace its hardcoded data with Riverpod state management. You'll implement:

1. A `MoodNotifier` that holds the list of mood entries
2. Providers that expose the state to the UI
3. Reactive screens that automatically update when data changes

The concepts above are all you need to understand before walking in. The lab will guide you through the code step by step.

---

## Verbal Pitch (~5 min per team)

Before leaving today, **pitch your project to the instructor**. This is informal — no slides needed.

### What to Cover (2 minutes max)

1. **The problem:** What health-related problem does your app address?
2. **Target users:** Who will use it? (patients, clinicians, caregivers?)
3. **3 key features:** What are the most important things the app will do?

### Why a Pitch?

The verbal pitch gives you early feedback before you invest time writing the full proposal. The instructor can flag scope issues, suggest features, or point out regulatory considerations you haven't thought of.

> **Full written proposal** is due at the end of **this week (Week 5)**. Use the template at `templates/project-proposal/PROPOSAL_TEMPLATE.md`. Submitting it now ensures Sprint 1 (Weeks 6–7) can start with a clear, approved scope.

---

## Checklist Before Leaving

- [ ] At least 10 user stories written as GitHub Issues on your project board
- [ ] Sprint 1 planned: stories selected, assigned, sprint goal written
- [ ] **Verbal pitch delivered** to the instructor
- [ ] Team understands the state management vocabulary (Provider, StateNotifier, `ref.watch`, `ref.read`)
- [ ] Everyone knows: full proposal due end of this week (Week 5), Flutter project setup happens in Week 6 lab

---

## Tips for Good Sprint Planning

1. **Be realistic** — it's better to finish fewer stories well than to leave many half-done
2. **Start with the skeleton** — navigation and basic screens first, features later
3. **Communicate daily** — even a quick message in your team chat about what you're working on
4. **Use the board** — move cards as you work, it helps the whole team see progress
5. **Ask for help early** — if you're stuck for more than 30 minutes, ask a teammate or the teacher
