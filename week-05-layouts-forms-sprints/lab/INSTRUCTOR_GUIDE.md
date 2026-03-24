# Week 5 Lab: Instructor Guide

**Course:** Multiplatform Mobile Software Engineering in Practice
**Lab Duration:** 2 hours
**Topic:** Sprint Planning Workshop
**Audience:** Teams formed in Week 4, familiar with Flutter basics, Git branching, and PRs from Weeks 1--4

> This document is for the **instructor only**. Students use the separate `README.md` workbook.

---

## Pre-Lab Checklist

Complete these **before students arrive**:

- [ ] All students have formed teams (from Week 4) -- check if any students are unassigned
- [ ] Have the proposal template ready (`templates/project-proposal/PROPOSAL_TEMPLATE.md`)
- [ ] Verify all students have GitHub accounts and can access the course organization
- [ ] Prepare a list of example project ideas for teams that are stuck
- [ ] Have a sample GitHub Projects board ready to show (or screenshots)
- [ ] Verify Flutter SDK works on lab machines (`flutter doctor` on at least one machine)
- [ ] Open the student workbook (`README.md`) on the projector
- [ ] Have the sprint review rubric handy (`templates/rubrics/sprint-review-rubric.md`) to explain expectations
- [ ] Prepare backup plan for students without teams (assign them to existing teams or form a new one)

### Room Setup

- Projector showing your browser with GitHub open
- Have one of your own repositories ready for live demos (repo creation, Projects board, branch protection)
- Students should sit with their teams -- rearrange seating if needed so team members are adjacent
- If teams have not finalized, handle this in the first 5 minutes before the Welcome

### If Students Have Not Formed Teams

This is the biggest risk for today's workshop. If students arrive without teams:

1. Ask who is unassigned -- raise hands
2. If 3--4 unassigned students exist, form them into a new team on the spot
3. If 1--2 students are unassigned, assign them to existing teams of 2 or 3
4. Do NOT let students work alone unless there is genuinely no alternative -- explain that team experience is a course learning objective
5. Spend no more than 5 minutes on this -- it cuts into workshop time

---

## Timing Overview

| Time | Duration | Activity | Type |
|------|----------|----------|------|
| 0:00--0:05 | 5 min | Welcome & workshop overview | Instructor talk |
| 0:05--0:25 | 20 min | Part 1: Repository setup | Team work (guided) |
| 0:25--0:40 | 15 min | Part 2: GitHub Projects board | Team work (guided) |
| 0:40--0:45 | 5 min | Break / catch-up buffer | --- |
| 0:45--1:10 | 25 min | Part 3: Writing user stories | Team work |
| 1:10--1:30 | 20 min | Part 4: Sprint 1 planning | Team work |
| 1:30--1:35 | 5 min | Break / catch-up buffer | --- |
| 1:35--1:55 | 20 min | Part 5: Flutter project setup + PR | Team work |
| 1:55--2:00 | 5 min | Proposal submission reminder + wrap-up | Instructor talk |

**Total:** 120 minutes (2 hours)

> **Pacing note:** The two 5-minute buffers are critical. This is a workshop, not a lecture -- teams will move at different speeds. Use the buffers to check in with every team and make sure nobody is stuck on Part 1 while others are on Part 3. Part 5 is shortened from the 30 minutes in the student workbook to 20 minutes. If teams move quickly through Parts 1--4, they can start Part 5 early and use the full 30 minutes.

---

## Detailed Facilitation Guide

### 0:00--0:05 --- Welcome & Workshop Overview (5 min)

**Type:** Instructor talk

**What to say (talking points, not a script):**

- "Today is different from every lab so far. No individual exercises. No starter projects. No TODOs."
- "Today you work as a team. By the end of this session, your team will have: a repository set up, a sprint planned, and a proposal submitted."
- "This mirrors how real software teams start a project. Before you write a single line of code, you plan."
- "In medical device development, the planning phase is even more formal. IEC 62304 requires documented requirements and a software architecture before implementation begins. Today we do a lightweight version of that."
- "Your project proposal is due at the end of this session. Use the template at `templates/project-proposal/PROPOSAL_TEMPLATE.md`."
- "I will walk you through each part, but most of the work is yours. I am here to help, not to lead."

**What students should be doing:**

- Sitting with their team members
- Opening their laptops and navigating to GitHub
- Having the student workbook open (on the projector or on their own screen)

**Checkpoint:** Before moving on, confirm that every student is sitting with their team. Ask: "Does everyone know who their team members are? If not, come see me now." Resolve any team formation issues before continuing.

**Common pitfall:** Students who missed Week 4 may not have a team. Handle this quickly -- either assign them to a team that needs members or form a new team from unassigned students.

---

### 0:05--0:25 --- Part 1: Repository Setup (20 min)

**Type:** Team work (guided)

**This section must be done carefully.** The repository and branch protection are the foundation for the entire project. Mistakes here cause problems for weeks.

#### 0:05--0:12 --- Demo: Create a Repository (7 min)

**Demo on projector:**

Walk through creating a new repository on GitHub, live. Use a throwaway name like `demo-mhealth-app`:

1. Click "New repository" on GitHub
2. Name: something descriptive (e.g., `mhealth-diabetes-tracker`)
3. Visibility: **Public** (so the instructor can see it)
4. Initialize with README: Yes
5. Add .gitignore: Select "Flutter" from the dropdown
6. Click "Create repository"

**Then demo adding collaborators:**

1. Go to Settings > Collaborators > Add people
2. Search by GitHub username
3. Set access to "Write"

**Key talking point:** "Only ONE person per team creates the repository. The rest are added as collaborators. Decide now who that person is -- usually the person most comfortable with GitHub."

**What to watch for:**

- Students setting the repository to **private**. It should be public so you can review their work. Walk around and check.
- Students all creating separate repositories instead of one per team. Remind them: one repo per team.
- Confusion about the organization -- if you are using a course GitHub organization, show them how to create the repo under the org instead of their personal account.

#### 0:12--0:18 --- Branch Protection Rules (6 min)

**Demo on projector -- this is CRITICAL:**

1. Go to Settings > Branches > Add branch protection rule
2. Branch name pattern: `main`
3. Check: "Require a pull request before merging"
4. Check: "Require approvals" -- set to 1
5. Check: "Do not allow bypassing the above settings"
6. Save changes

**Say:** "This is the most important configuration today. From now on, nobody pushes directly to `main`. All changes go through Pull Requests. This is how every professional team works. It protects the main branch from accidental or untested changes."

**Talking point:** "In healthcare software, regulatory bodies like the FDA expect evidence that code changes are reviewed before they reach production. Branch protection is the first line of defense."

**What to watch for:**

- Teams that skip branch protection because it seems inconvenient. Insist on it -- it is a course requirement.
- Students who do not check "Do not allow bypassing" -- without this, the repo owner can still push directly to main.
- The branch protection UI on GitHub changes occasionally. If students see a different layout than what you are showing, help them find the equivalent settings.

#### 0:18--0:25 --- Everyone Clones and Verifies (7 min)

**Say:** "Now everyone on the team clones the repo. Open your terminal and run `git clone` with the SSH URL."

**Have each team member:**

1. Clone the repository
2. Run `git remote -v` to confirm the remote is set
3. Run `git branch -a` to see available branches

**Checkpoint:** Walk around the room. Ask each team: "Can every member clone? Show me your terminal." Every team member must have a local clone before you move on.

**Common pitfalls:**

- Students who forgot their SSH setup from Week 1. Help them quickly, or fall back to HTTPS cloning.
- Students who clone into the wrong directory (e.g., inside another git repo). Remind them to `pwd` first.
- One student on the team cannot accept the collaborator invitation because they did not check their email. Have them go to `github.com/notifications` to accept directly.

---

### 0:25--0:40 --- Part 2: GitHub Projects Board (15 min)

**Type:** Team work (guided)

#### 0:25--0:30 --- Demo: Create a Projects Board (5 min)

**Demo on projector:**

1. Go to the repository > Projects tab > "New project"
2. Select "Board" as the template
3. Name it something like "Sprint Board"

**Create the five columns:**

1. **Backlog** -- all planned work, not yet selected for a sprint
2. **Sprint Backlog** -- stories selected for the current sprint
3. **In Progress** -- someone is actively working on this
4. **In Review** -- a Pull Request has been opened, waiting for review
5. **Done** -- merged to main

**Explain:** "This is a simplified Kanban board. Cards move left to right as work progresses. At any time, each team member should have at most 1--2 cards in 'In Progress'. This prevents context-switching and ensures focus."

**Talking point:** "Kanban boards originated in manufacturing -- Toyota used them to optimize production lines. In healthcare software, boards like this help teams track compliance-related tasks alongside feature development."

#### 0:30--0:40 --- Teams Set Up Their Boards (10 min)

**Say:** "Set up your project board now. Create the five columns exactly as shown. You have 10 minutes."

**Walk around the room.** Check each team.

**Common pitfalls:**

- GitHub Projects UI has changed significantly over the past few years. The workbook instructions might not match exactly. If a team is confused, help them through the current UI.
- Teams creating too many columns (e.g., "Design", "Testing", "Deployment"). Five is enough for this course. They can add more later if needed.
- Teams creating too few columns (e.g., just "To Do" and "Done"). They need all five to support the PR workflow.
- Teams not linking the board to their repository. The board should be created from the repository's Projects tab, not from the user's profile.

**Checkpoint:** "Does every team have a board with exactly five columns? Backlog, Sprint Backlog, In Progress, In Review, Done? Show me." Verify before moving on.

---

### 0:40--0:45 --- Break / Catch-Up Buffer (5 min)

- Students who are on track: take a real break, stretch, get water
- Teams who are behind: use this time to finish their board or resolve cloning issues
- Walk around and do a quick status check with every team. Ask: "Repo created? Branch protection on? Board set up?"
- If any team is significantly behind, assign yourself or a TA to help them while the rest proceed
- Quick preview: "After the break, you will start writing user stories. Start thinking about the features your app needs."

---

### 0:45--1:10 --- Part 3: Writing User Stories (25 min)

**Type:** Team work

**This is the most intellectually demanding part of the workshop.** Students need to shift from thinking about code to thinking about users.

#### 0:45--0:52 --- Demo: Write One User Story as a GitHub Issue (7 min)

**Demo on projector -- write a user story live:**

1. Go to the repository > Issues > New issue
2. Title: "Log mood entry with score and note"
3. Body:

```
**User Story:**
As a patient, I want to log my mood with a score and optional note,
so that I can track how I feel over time.

**Acceptance Criteria:**
- [ ] User can select a mood score from 1 to 10
- [ ] User can optionally add a text note
- [ ] Entry is saved with a timestamp
- [ ] User sees confirmation after saving

**Estimate:** M
```

4. Add a label (create the `feature` label if it does not exist)
5. Submit the issue
6. Add the issue to the project board in the Backlog column

**Explain the format:**

- "As a [type of user], I want to [do something], so that [I get some benefit]" -- this is the standard user story format
- Acceptance criteria are checkboxes. "How do you know the story is done? When all the boxes are checked."
- Size estimates: S (under 2 hours), M (2--4 hours), L (4--8 hours). "If it is XL -- more than 8 hours -- break it down into smaller stories."

**Healthcare context:** "In a real clinical project, user stories would come from interviewing clinicians, patients, and caregivers. You would sit in a hospital, watch workflows, and identify pain points. For this course, think about who uses your app and what they need to accomplish."

#### 0:52--1:10 --- Teams Write Their Stories (18 min)

**Say:** "Now it is your turn. As a team, write at least 10--15 user stories covering your app's core features. Create each story as a GitHub Issue with the format I just showed you. Add them all to your Backlog column. You have 18 minutes."

**Walk around actively.** This is where teams need the most help. Spend 2--3 minutes with each team.

**What to look for and correct:**

- **Stories that are too vague.** "Make the app work" is not a user story. Help teams be specific: "What does the user see? What do they do? What happens next?"
- **Stories that are too technical.** "Implement Provider pattern" or "Set up Firebase" are tasks, not user stories. Redirect: "Who benefits from this, and how? The user story should be about user value, not implementation details."
- **Missing acceptance criteria.** Without checkboxes, the team will not know when the story is done. Push them to add at least 3 criteria per story.
- **Everything estimated as "Medium".** Help teams calibrate. "Adding a text field to a screen is Small. Building an entire login flow is Large."
- **No labels.** Remind teams to create and apply labels: `feature`, `ui`, `backend`, `auth`, `documentation`.

**Suggested stories for teams that are stuck (use these as prompts):**

- Authentication: register, login, logout, password reset
- Home screen: display summary, show recent entries
- Data entry: create new entry, edit existing entry, delete entry
- History/timeline: view past entries, filter by date, search
- Settings: change notification preferences, update profile
- Navigation: bottom nav bar, drawer menu

**Healthcare tie-in while walking around:** "Think about your users. If you are building a medication tracker, a patient needs to log doses quickly -- maybe in 10 seconds. A caregiver might need to see all medications at a glance. A doctor might need weekly adherence reports. Different users, different stories."

**Checkpoint:** At 1:08, give a 2-minute warning. Then ask: "How many stories does each team have? Raise your hand if you have 10 or more." Aim for every team to have at least 10. If a team has fewer than 5, they need to keep writing during Part 4.

**Common pitfalls:**

- Teams spending too long debating the "perfect" wording. Remind them: "Good enough now is better than perfect later. You can always edit the issue."
- Teams creating one massive story instead of breaking it into pieces. "If a story has more than 5 acceptance criteria, it is probably too big. Split it."
- Teams forgetting to add stories to the project board. The board should populate as they create issues.

---

### 1:10--1:30 --- Part 4: Sprint 1 Planning (20 min)

**Type:** Team work

#### 1:10--1:15 --- Explain the Sprint Structure (5 min)

**Say:**

- "Sprint 1 covers weeks 5 through 7. You have about 3 weeks of work. The Sprint Review happens in Week 7."
- Show the sprint review rubric (`templates/rubrics/sprint-review-rubric.md`) briefly on the projector. Point to the key criteria: Sprint Goal Achievement (25 points), Demo Quality (20 points), Git Workflow (20 points), Teamwork (15 points).
- "Each team member can realistically complete 2--4 medium stories in a sprint. Do not overcommit."
- "Focus Sprint 1 on the app skeleton: navigation between screens, basic UI, data models. Do NOT try to build advanced features yet."

**Draw on the whiteboard or describe:**

```
Sprint 1 (Weeks 5-7): Skeleton + navigation + basic screens
Sprint 2 (Weeks 8-10): Core features + API integration
Sprint 3 (Weeks 11-13): Polish + auth + final features
```

**Healthcare tie-in:** "Agile and Scrum are used extensively in health tech companies. Many medical device companies use adapted Scrum processes that include regulatory checkpoints within each sprint. At the end of every sprint, they verify not only that the feature works but that it meets safety and documentation requirements."

#### 1:15--1:30 --- Teams Plan Sprint 1 (15 min)

**Say:** "Select stories for Sprint 1. Move them from Backlog to Sprint Backlog on your project board. Assign each story to a team member. Then write a sprint goal -- one sentence describing what the team will achieve by Week 7."

**Walk around and guide each team.**

**What to check:**

- **Are they being realistic?** A common mistake is selecting too many stories. "It is better to finish 5 stories well than to start 10 and finish none. You are graded on completion, not ambition."
- **Are stories assigned?** Every story in the Sprint Backlog should have an assignee. "Every team member should know exactly what they are working on when they leave today."
- **Is there a sprint goal?** It should be one sentence. Example: "Build the app skeleton with navigation between home, entry, and history screens, with basic data entry working locally." The goal goes in a pinned issue.
- **Is anyone overloaded?** No team member should have more than 4 stories. If someone has 6 and another has 1, redistribute.

**Sprint 1 story suggestions (for teams that need direction):**

1. App skeleton with bottom navigation (M)
2. Home screen with placeholder content (S)
3. Data entry screen with form fields (M)
4. History/list screen showing sample data (M)
5. Basic data model classes (S)
6. Settings screen placeholder (S)

**Common pitfalls:**

- Teams being too ambitious. "We will build the entire app in Sprint 1!" Redirect them: skeleton and navigation first.
- Teams not assigning stories to individuals. Everyone should leave knowing their first task.
- Sprint goal that is a paragraph instead of a sentence. Help them distill it.
- Teams that still have fewer than 10 stories. Have them continue writing stories AND plan simultaneously.

**Checkpoint:** At 1:28, ask each team: "Show me your Sprint Backlog column. Are all stories assigned? What is your sprint goal?" Every team should be able to answer all three.

---

### 1:30--1:35 --- Break / Catch-Up Buffer (5 min)

- Students who are on track: real break
- Teams who are behind on user stories: continue writing
- Teams who have not assigned Sprint 1 work: finish assignments now
- Walk around and do a final check on Parts 1--4 before moving to Part 5
- Quick head count: "How many teams have their sprint planned? How many still need a few more minutes?"
- If more than half the teams are behind, consider extending this buffer into Part 5 time. Flutter project setup can be completed outside of lab if needed.

---

### 1:35--1:55 --- Part 5: Flutter Project Setup + PR (20 min)

**Type:** Team work

**This is the teams' first real Pull Request workflow experience.** It ties together everything from Weeks 1--2 (Git branching, PRs) with the new team context.

#### 1:35--1:40 --- Explain the Workflow (5 min)

**Say:**

- "One team member creates the Flutter project on a feature branch. Not on main -- on a branch."
- "Clean up the default counter app. Replace it with a minimal skeleton: an app shell, a home screen, and 2--3 placeholder screens."
- "Push the branch, create a PR. A teammate reviews and merges it. Then everyone pulls main."
- "This is your first team PR. Treat it like a real code review."

**Quick demo on projector (or just show the commands):**

```bash
git checkout -b setup/flutter-project
flutter create --org com.yourteam your_app_name
cd your_app_name
# Clean up lib/main.dart, create screen stubs
git add .
git commit -m "Set up Flutter project with basic navigation"
git push -u origin setup/flutter-project
# Create PR on GitHub, teammate reviews and merges
```

**What to watch for:**

- **Where to create the Flutter project.** Teams need to decide: at the repository root, or in a subdirectory? Both approaches work, but they should decide together. If the repo already has a README and .gitignore at the root, creating the Flutter project in a subdirectory (e.g., `app/`) avoids conflicts. Alternatively, they can run `flutter create .` at the repo root if the repo is otherwise empty.
- **Package naming.** The `--org` flag sets the reverse domain. Help teams choose something sensible (e.g., `com.teamname` or `pl.edu.agh.teamname`).

#### 1:40--1:55 --- Teams Work (15 min)

**Let the teams work.** Walk around and help as needed.

**Sequence that should happen:**

1. One team member creates the Flutter project on a feature branch
2. They clean up `lib/main.dart` -- remove the counter app, set up a basic MaterialApp with their app name
3. They create placeholder screen files in `lib/screens/` (at least home_screen.dart and 1--2 others)
4. They add simple `Navigator.push` navigation between screens
5. They commit, push, and create a PR
6. A different team member reviews the PR on GitHub (even a brief "looks good" comment is fine for the first PR)
7. The reviewer merges the PR
8. Everyone on the team runs `git checkout main && git pull`

**Common pitfalls:**

- **Creating the Flutter project directly on main.** Remind them: feature branches. That is the whole point of branch protection.
- **Students trying to push to main and getting rejected.** This is actually a GOOD thing. It means branch protection is working. Say: "The rejection is correct. Create a branch first."
- **Flutter project created inside a nested directory unintentionally.** For example, they run `flutter create my_app` inside the repo, creating `repo/my_app/lib/...` when they wanted `repo/lib/...`. Help them decide on the structure.
- **Merge conflicts with the README.** If the Flutter project overwrites the README that was created during repo initialization, they will get a conflict on the PR. Help them resolve it.
- **Nobody knows how to review a PR.** Show them: go to the PR on GitHub, click "Files changed", look at the diff, leave a comment or approve, then merge.

**Checkpoint:** "Has every team merged their Flutter project to main? Has every team member pulled the latest main? Run `flutter run` and show me the app launching."

**If a team is behind:** Reassure them that the Flutter project setup can be completed outside of lab. The critical deliverables for today are Parts 1--4 and the proposal.

---

### 1:55--2:00 --- Proposal Submission Reminder + Wrap-Up (5 min)

**Type:** Instructor talk

**What to say:**

- "Before you leave today, submit your project proposal. Use the template at `templates/project-proposal/PROPOSAL_TEMPLATE.md`. Commit it to your team repo."
- "If you have not finished the proposal, you have until end of day today. But I strongly recommend finishing it now while you are together."
- "Sprint 1 starts NOW. Your Sprint Review is at Week 7. That means you have about 3 weeks to complete the stories you selected today."
- "Start working on your assigned stories this week. Do not wait until the week before the review."
- "Next week's lab is project work time. Come prepared with questions and progress to show."

**Preview of what to expect at Sprint Review:**

- 10-minute demo of working features
- Show your project board and PR history
- Brief retrospective: what went well, what did not
- Plan for Sprint 2
- Graded on the rubric I showed earlier (100 points per review, reviews are 25% of the course grade)

**Final words:**

- "Today was very different from previous labs. You did not write much code, but you did something equally important -- you set up the infrastructure and process that will carry you through the rest of the course."
- "A good plan saves you time later. A bad plan -- or no plan -- means chaos at Week 7."
- "Go build something great."

---

## Instructor Notes: Sprint Planning Guidance

### How This Workshop Differs from Regular Labs

Previous labs had a clear structure: follow the workbook, complete exercises, check off TODOs. This workshop is deliberately less structured. Teams need to make their own decisions about their project, their stories, and their plan.

Your role shifts from "instructor leading exercises" to "facilitator walking around helping teams." Budget your time accordingly:

- Spend roughly equal time with each team
- Do not get pulled into one team's problems for 15 minutes while others wait
- If a team is blocked on something you cannot resolve quickly (e.g., a GitHub permissions issue), note it, help them work around it, and come back later
- Keep an eye on the clock and announce transitions between parts

### Facilitating Without Dictating

It is tempting to tell teams exactly what stories to write or how to structure their project. Resist this. The learning happens when they struggle with these decisions. Instead:

- Ask guiding questions: "Who is the primary user of your app? What do they need to accomplish?"
- Challenge assumptions: "Why is that a large story? Could you break it down?"
- Redirect when stuck: "Start with the simplest possible version. What is the minimum your home screen needs to show?"

---

## Instructor Notes: Evaluating Proposal Quality

Review proposals after the session (or as they are submitted). Look for:

### Green Flags (Strong Proposals)

- Clearly describes a specific health-related problem -- not just "a health app" but "a medication adherence tracker for elderly patients with polypharmacy"
- Scope is realistic for 3 sprints (9 weeks): 3--5 core screens, one API, authentication
- Target users are identified with concrete needs
- Technical approach is reasonable for the team's skill level
- Wireframes show a clear user flow, even if hand-drawn
- Risks are honest and mitigation strategies are concrete

### Yellow Flags (Needs Discussion)

- Problem statement is generic ("improve health") -- ask the team to be more specific
- Scope is on the edge -- either too ambitious or too minimal
- Wireframes are missing or show only one screen
- No clear API integration planned (this is a course requirement)
- Risk section is empty or trivially filled ("no risks identified")

### Red Flags (Requires Intervention)

- No clear health focus -- the app is a generic to-do list or social media clone with "health" tacked on
- Scope is wildly ambitious ("build an AI diagnostic system with real-time sensor integration")
- Minimum requirements not covered (fewer than 3 screens, no API, no auth)
- Team composition is unbalanced (e.g., one person listed for all development, others have no role)
- Proposal is copy-pasted from the internet or another team

### What to Do About Problem Proposals

- Send the team a GitHub Issue on their repo with specific, actionable feedback
- Give them until Week 6 to revise and resubmit
- For red-flag proposals, schedule a 5-minute conversation before or after the Week 6 lab
- Do not reject proposals outright -- guide the team toward a better version

---

## Instructor Notes: Handling Team Dynamics

### Uneven Skill Levels

This is the most common issue. Some students have been programming for years; others are writing their first real code in this course.

- **Pair stronger students with newer ones on stories.** Suggest that experienced students take on the more complex stories but pair-program with a less experienced teammate.
- **Assign "glue" tasks to less experienced students.** Creating screen stubs, writing README documentation, setting up labels, and managing the project board are all valuable contributions that do not require deep coding skills yet.
- **Frame it positively.** "Teaching your teammate makes you a better developer. Explaining something forces you to truly understand it."

### Absent Team Members

- Contact them via whatever communication channel the course uses (email, Discord, etc.)
- Assign their stories to other team members temporarily
- If a student misses today's workshop, make sure their teammates can bring them up to speed -- they need to clone the repo, review the board, and understand the sprint plan
- If a student is consistently absent, this becomes a team dynamics issue to address in the retrospective at Sprint Review

### Disagreements on Project Idea

- Help mediate. Ask each person to pitch their idea in 30 seconds.
- Remind the team: "This is a learning project. The specific topic matters less than the process. Pick something everyone can be excited about, even if it is not your first choice."
- If the team truly cannot agree, suggest a compromise: combine elements of two ideas, or vote and commit to the majority choice.
- Last resort: you choose for them. "Build a medication adherence tracker. It covers all the requirements and has clear user stories. Go."

### Students Who Want to Work Alone

- Explain why team experience is a course learning objective: "In your career, you will almost never build software alone. Learning to collaborate, review code, and manage conflicts is as important as learning Flutter."
- If a student has a compelling reason (e.g., severe schedule conflicts with all potential teammates), accommodate them -- but warn that they will have 3--4x the individual workload.
- Solo students still must use the PR workflow: create branches, open PRs, document their review (self-review is acceptable in this case).

### Teams of 2

- Acceptable, but both members will have more work per person.
- Recommend a slightly smaller scope -- 3 screens instead of 4--5, fewer user stories.
- They still need to use the PR workflow and review each other's code.

### Teams of 5+

- Split into two smaller teams.
- 5-person teams lead to coordination overhead that outweighs the benefits. Someone always ends up with nothing to do.
- If splitting is not possible, insist on very clear role division and more stories in the sprint to keep everyone busy.

---

## Where Students Typically Get Stuck

1. **GitHub Projects board.** The UI has changed frequently over the past year. If the workbook screenshots do not match what students see, help them navigate the current interface. The core concept -- columns with cards that move left to right -- remains the same regardless of UI changes.

2. **Writing user stories in the proper format.** Students instinctively write tasks ("implement database", "add button") instead of user stories ("as a patient, I want to..."). This requires active correction. Walk around and read their stories. Rewrite one or two together with the team.

3. **Size estimation.** Everything seems "Medium" at first. Help teams calibrate by anchoring: "Adding a text label to a screen is Small. Building a complete login flow with validation and error handling is Large. Most single-screen features with a form and a list are Medium."

4. **Branch protection rejections.** Students try to push to main and get rejected. This is the desired behavior. When a student comes to you confused about a rejection, congratulate them: "Branch protection is working. Create a feature branch, push that, and open a PR."

5. **Flutter project setup -- structure decisions.** Teams agonize over folder structure and package naming. Remind them: "Pick something reasonable and move on. You can always restructure later. The goal today is to have a skeleton, not a perfect architecture."

---

## If Running Out of Time

Priority order (what MUST be completed before students leave):

1. **Repository setup + branch protection** -- foundational. Without this, teams cannot do any work.
2. **At least 5 user stories written** -- enough to start Sprint 1, even if the full 10--15 are not done.
3. **Sprint 1 stories selected and assigned** -- every team member needs to know what to work on.
4. **Flutter project created** -- can be done outside of lab if needed. Assign one team member to do it and have the team review the PR asynchronously.
5. **Full 10+ user stories, labels, and board fully populated** -- can be completed as homework before next week.

### Recovery Strategies

**If Parts 1--2 take too long (past 0:45):**

- Skip the second buffer. Go directly from Part 2 into Part 3.
- Shorten the user story demo to 3 minutes instead of 7. Just show the format and let them go.

**If Part 3 takes too long (past 1:15):**

- Combine Parts 3 and 4. "Write your stories AND select Sprint 1 stories at the same time. Focus on the most important 5--8 stories first."

**If teams are stuck on their project idea:**

- Offer ready-made ideas: medication tracker, symptom diary, exercise logger for physical therapy, mental health mood journal, sleep tracker, hydration reminder, blood pressure log.
- "Pick one. You can always pivot later. The important thing is to start."

**If GitHub is down or the network is unreliable:**

- Have teams write user stories on paper or in a shared document. They can enter them as GitHub Issues later.
- The repo setup and board can be done after class. Focus on the planning conversation.

---

## End-of-Lab Assessment

### Minimum Completion Checklist

Every team should leave the lab with:

- [ ] Team repository created with branch protection on `main`
- [ ] All team members can clone and push to branches
- [ ] GitHub Projects board set up with 5 columns (Backlog, Sprint Backlog, In Progress, In Review, Done)
- [ ] At least 10 user stories created as GitHub Issues with proper format, acceptance criteria, and estimates
- [ ] Sprint 1 stories selected, assigned to team members, and sprint goal written
- [ ] Flutter project skeleton committed and merged to main (via PR)
- [ ] Project proposal submitted (committed to the repo using the template)

### Quick Verification Method

In the last 3 minutes, visit each team and ask them to show you:

1. Their repository on GitHub with branch protection enabled
2. Their project board with cards in the Sprint Backlog column
3. Their sprint goal (pinned issue or visible on the board)
4. The Flutter app running on at least one team member's machine

Teams that can show all four are in good shape.

### For Teams That Did Not Finish

- Reassure them: "The workbook covers everything. Complete the remaining steps before next week's lab."
- Prioritize: if they have the repo and branch protection, everything else can be done asynchronously.
- Remind them: "Sprint 1 has started. Do not wait until next week's lab to begin working on your stories."
- Encourage them to communicate as a team this week -- even a quick message about who is working on what.

### After the Lab: Your Checklist

- [ ] Review submitted proposals within 2--3 days
- [ ] Send feedback as GitHub Issues on each team's repo
- [ ] Flag any teams that need to revise their proposal
- [ ] Verify that every team's repo has branch protection enabled
- [ ] Check that every team's project board has stories in the Sprint Backlog
- [ ] Note any teams that seem behind or disorganized -- check in with them at the start of Week 6
