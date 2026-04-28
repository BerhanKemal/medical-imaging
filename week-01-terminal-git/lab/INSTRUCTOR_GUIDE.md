# Week 1 Lab: Instructor Guide

**Course:** Multiplatform Mobile Software Engineering in Practice
**Lab Duration:** 90 minutes
**Topic:** Terminal, Git & GitHub
**Audience:** Students with basic programming experience — zero prior terminal/git experience

> This document is for the **instructor only**. Students use the separate `README.md` workbook.

---

## Pre-Lab Checklist

Complete these **before students arrive**:

- [ ] Verify Git is installed on all lab machines (`git --version` in terminal)
- [ ] Verify SSH connectivity is not blocked by the campus network (`ssh -T git@github.com`)
- [ ] Have HTTPS backup instructions ready in case SSH is blocked on lab network
- [ ] Open the student workbook (`README.md`) on the projector
- [ ] Prepare a personal GitHub account for live demos (or use a throwaway)
- [ ] Create the demo repository `agh-mhealth/week-01-exercises` on GitHub (or verify it exists)
- [ ] Ensure `students/` directory exists in the exercise repository
- [ ] Test the projector: increase terminal font size to at least 18pt
- [ ] Have a browser tab open to github.com ready for SSH key demo
- [ ] Print or have digital copies of this guide for yourself

### Room Setup

- Projector showing your terminal (large font, dark background recommended)
- Browser window with GitHub ready
- Students should sit where they can see the projector AND have access to their own machine
- If lab has both macOS and Windows machines, know which students are on which OS

### If Git Is Not Installed

Windows machines may not have Git Bash. Fallback plan:

1. Download from [git-scm.com](https://git-scm.com/downloads) --- takes ~5 min
2. Use default installation options
3. After install, students must **close and reopen** their terminal
4. If download is slow on lab WiFi, have USB drives with the installer ready

---

## What's Already Built Into the Workbook

The student workbook (`README.md`) has strong written scaffolding you can leverage:

- 4 progress breadcrumbs (visual progress tracking)
- 4 TL;DRs, 4 checkpoints, 4 self-check sections
- 7 interactive quizzes with contextual healthcare feedback
- 3 "Try to break it" exercises (intentional error practice)
- 3 "Pair moment" boxes (peer collaboration)
- 4 common-mistake warnings, 2 pro tips
- 2 "How does this actually work?" collapsible deep dives
- 1 healthcare context box, 1 end-of-lab reflection
- Mermaid diagrams, FAQ troubleshooting section

**The gap this guide fills:** The workbook tells students *what to do*, but the instructor needs a strategy for *how to run the room* --- pacing, energy management, where to demo live vs let them type, how to handle stuck students, and where to inject interaction.

---

## Timing Overview

| Time | Duration | Activity | Type |
|------|----------|----------|------|
| 0:00--0:05 | 5 min | Opening Hook | Instructor talk |
| 0:05--0:30 | 25 min | Part 1: Terminal Basics | Demo + type-along + exercise |
| 0:30--1:05 | 35 min | Part 2: Git Basics | Demo + type-along + self-paced |
| 1:05--1:20 | 15 min | Part 3: SSH Setup | Guided step-by-step |
| 1:20--1:30 | 10 min | Part 4: Push & Clone | Fast-paced guided |
| 1:30--1:35 | 5 min | Closing | Wrap-up |

**Total:** 90 minutes (with 5-min buffer at the end)

> **Pacing note:** There are no explicit break slots. The self-paced exercise transitions (Exercise 1.8 at ~0:22 and Exercise 2.8 at ~0:52) act as natural breathing room. If students are struggling, use the exercise time as catch-up.

---

## Minute-by-Minute Execution Plan

### Opening Hook (0:00--0:05)

**Goal:** Create curiosity before touching the terminal.

Choose ONE of these three options:

#### Option A --- "The Disaster Demo"

1. Project your screen. Open a folder with files named:
   ```
   report.docx
   report_v2.docx
   report_v2_final.docx
   report_v2_final_REAL.docx
   report_v2_final_REAL_submitted.docx
   report_v2_final_REAL_submitted_fixed.docx
   ```
2. Ask: *"How many of you have a folder that looks like this?"* (Laughter, recognition.)
3. Say: *"By the end of today, you'll never need to do this again."*

#### Option B --- "The Time Machine Demo"

1. Open a terminal in a Git repo with 50+ commits (use a real open-source project, or prepare one).
2. Run `git log --oneline --graph` --- show the branching history.
3. Run `git show HEAD~20` --- jump back 20 commits. *"This is what your project looked like 3 weeks ago. Git remembers everything."*
4. Say: *"Today you'll learn to build this."*

#### Option C --- "The Healthcare Stakes"

1. Show a headline about a medical device software bug (e.g., Therac-25, or a recent insulin pump recall).
2. Ask: *"What if someone changed the code and nobody tracked who, when, or why?"*
3. Say: *"Version control isn't optional in healthcare software. It's a legal requirement. Let's learn it."*

> **Recommendation:** Option A is lightest and gets laughs. Option C is strongest for students. Choose based on your audience's energy at the start of class.

---

### Part 1: Terminal Basics (0:05--0:30)

**Teaching mode:** Live coding on projector, students type along.

#### Block 1.1: Navigation (0:05--0:15) --- 10 min

Covers workbook sections 1.1 (`pwd`), 1.2 (`ls`), 1.3 (`cd`).

| Minute | What happens | Mode |
|--------|-------------|------|
| 0:05 | Demo `pwd` on your screen. Ask *"Where am I?"* before showing output | Demo |
| 0:06 | Students type `pwd` | Type-along |
| 0:07 | Demo `ls`, then `ls -la`. Point out hidden files (`.bashrc`, `.ssh/`) | Demo |
| 0:08 | Students type `ls` and `ls -la` | Type-along |
| 0:09 | Demo `cd Desktop`, `pwd`, `cd ..`, `pwd`. Show the path changing | Demo |
| 0:10 | Students navigate: `cd Desktop` -> `pwd` -> `cd ..` -> `cd ~` | Type-along |
| 0:12 | **Teach Tab-completion live:** Type `cd Desk` then press Tab. *"The terminal finishes it for you."* | Demo |
| 0:13 | **"Try to break it":** Have everyone type `cd NonExistentFolder`. Read the error together. *"The terminal is trying to help you. Read the message."* | Interactive |
| 0:14 | **Quiz (workbook 1.3):** Run it verbally --- *"What does `cd ..` do? Shout it out."* | Verbal |

**Key technique:** Before EVERY new command, ask *"What do you think this will do?"* Wait 3 seconds. Then demonstrate. This predict-then-observe cycle is the strongest learning technique for procedural skills.

#### Block 1.2: Creating & Deleting (0:15--0:22) --- 7 min

Covers workbook sections 1.4 (`mkdir`), 1.5 (`cat`, `touch`), 1.6 (`rm`).

| Minute | What happens | Mode |
|--------|-------------|------|
| 0:15 | Demo `mkdir mhealth-course`, `cd mhealth-course`, `mkdir -p week-01/exercises` | Demo |
| 0:16 | Students create the same structure | Type-along |
| 0:17 | Demo `touch notes.txt`, `echo "Hello" > notes.txt`, `cat notes.txt` | Demo |
| 0:18 | Students create and write to a file | Type-along |
| 0:19 | **Critical moment --- `>` vs `>>`:** Demo BOTH. Show that `>` destroys the file. Students gasp. *"This has caused real data loss in clinical trials."* | Demo |
| 0:20 | Demo `rm notes.txt` --- *"No trash. No undo. Gone."* | Demo |
| 0:21 | Students practice rm with a test file | Type-along |
| 0:22 | **Quiz (workbook 1.5):** `>` vs `>>` --- quick show of hands | Verbal |

#### Block 1.3: Exercise 1.8 --- Build a Project Structure (0:22--0:30) --- 8 min

**Make this a timed pair challenge:**

1. Say: *"You have 5 minutes. Work in pairs. Build the folder structure from Exercise 1.8. First pair to show me the correct `ls -R` output gets bragging rights."*
2. Project the expected output on screen
3. **Walk the room constantly.** Look at screens. If someone is stuck, give ONE hint, then move on
4. At 5 minutes, ask for a volunteer to show their `ls -R` on the projector
5. **Pair moment (workbook 1.8):** *"Compare your output with your neighbor."*

> **Energy management:** This is the first "free swim" moment. Some students will finish in 2 minutes, others will struggle. Have a stretch task ready: *"Done early? Try `man ls` and find a flag you didn't know about."*

**Checkpoint announcement:** *"Part 1 done. You now know the 10 commands that replace clicking through Finder. Every developer uses these daily."*

---

### Part 2: Git Basics (0:30--1:05)

**Teaching mode:** Demo first, then guided type-along. The commit exercise is self-paced.

#### Block 2.1: Concepts & First Commit (0:30--0:50) --- 20 min

Covers workbook sections 2.1 (What Is Git?), 2.2 (Configuring Git), 2.3 (`git init`), 2.4 (`git status`), 2.5 (Your First Commit).

| Minute | What happens | Mode |
|--------|-------------|------|
| 0:30 | Explain Git in ONE sentence: *"Git is unlimited undo for your entire project."* | Lecture |
| 0:31 | Students run `git config` commands (workbook 2.2) | Type-along |
| 0:32 | Demo `git init` in a new folder. Show `.git/` with `ls -la`. *"This hidden folder IS Git."* | Demo |
| 0:33 | Students create `my-first-repo` and `git init` | Type-along |
| 0:35 | Demo `git status` on empty repo. *"This is the command you'll type most. It's your dashboard."* | Demo |
| 0:36 | **"Try to break it" (workbook 2.4):** Have students run `git status` in `/tmp`. Read the error. Navigate back | Interactive |
| 0:38 | **The Three Areas --- Physical Demo** (see below) | **KEY MOMENT** |

**Physical Demo (optional but powerful):**

Bring three items to class: a folder/tray labeled "Working Directory", a box labeled "Staging Area", and a sealed container labeled "Repository". Have a student come up and physically move paper sheets between them as you narrate:

1. *"You write code"* -> student holds a paper sheet (the file)
2. *"git add"* -> student puts the sheet in the box
3. *"git commit"* -> student seals the box and puts it on the shelf
4. *"Can you unseal that box?"* -> No. That's why commits are permanent.

If you don't want physical props, use the shipping box analogy from the workbook and draw it on the whiteboard.

| Minute | What happens | Mode |
|--------|-------------|------|
| 0:42 | Walk through Steps 1--4 of the first commit (workbook 2.5) live on projector | Demo |
| 0:45 | Students do the same: create README.md, `git add`, `git status`, `git commit` | Type-along |
| 0:47 | **Critical:** After commit, run `git status` again. Show "nothing to commit, working tree clean." *"That's the green light."* | Demo |
| 0:48 | Demo `git log` and `git log --oneline` | Demo |
| 0:49 | **Quiz (workbook 2.5):** *"What does the staging area contain after a commit?"* | Quick verbal |

#### Block 2.2: Diff & Commit History Exercise (0:50--1:05) --- 15 min

Covers workbook sections 2.7 (`git diff`), 2.8 (Exercise: Build a Commit History), 2.9 (`.gitignore`).

| Minute | What happens | Mode |
|--------|-------------|------|
| 0:50 | Demo `git diff` --- modify README.md, show the `+`/`-` lines. *"Always diff before add. Always status before commit."* | Demo |
| 0:52 | **Self-paced exercise:** Students work through Commits 1--5 from workbook 2.8 | Self-paced |
| 0:58 | **Commit 6 (their own):** *"This one is yours. Pick any topic from their field. No copy-paste."* Give 3--4 minutes | Self-paced |
| 1:00 | **Pair moment (workbook 2.8):** *"Show your neighbor your `git log --oneline`. Can they understand what you did from the messages alone?"* | Peer review |
| 1:02 | Quick `.gitignore` demo (workbook 2.9). 2 min, just type along | Type-along |
| 1:04 | **Checkpoint announcement:** *"Part 2 done. You have a Git repo with 6+ commits. You're version-controlling like a professional."* | Announcement |

> **Walking the room is critical here.** Common issues during self-paced work: forgetting `git add`, running `git commit` without `-m`, being in the wrong directory.

---

### Part 3: SSH Setup (1:05--1:20)

**Teaching mode:** Careful step-by-step. This is where students get stuck most.

Covers workbook sections 3.1 (GitHub Account), 3.2 (Generate SSH Key), 3.3 (Add Key to GitHub), 3.4 (Test Connection).

**Pre-flight check (30 seconds):** *"Raise your hand if you already set up SSH keys in Week 0."* Those students skip to section 3.4 (test connection) and become helpers.

| Minute | What happens | Mode |
|--------|-------------|------|
| 1:05 | **GitHub account check:** *"Open github.com. Raise your hand when you're logged in."* Wait for everyone | Sync point |
| 1:07 | Demo `ssh-keygen` on projector. Explain each prompt. *"Press Enter three times."* | Demo |
| 1:08 | Students run `ssh-keygen` | Type-along |
| 1:10 | Demo copying the public key (`cat ~/.ssh/id_ed25519.pub`). Show the OS-specific clipboard commands | Demo |
| 1:11 | Students copy their public key | Type-along |
| 1:12 | **Screen walkthrough:** Project GitHub Settings -> SSH Keys -> New SSH Key. Walk through it step by step | Demo |
| 1:13 | Students add their key to GitHub | Self-paced |
| 1:15 | **The Reveal:** `ssh -T git@github.com` --- *"Type this and let's see who gets the green light."* | Interactive |

**Handling stuck students:**

- **"Permission denied":** 90% of the time they copied the wrong key or added extra whitespace. Have them `cat ~/.ssh/id_ed25519.pub` again
- **"Connection timed out":** Campus network may block port 22. Switch to HTTPS fallback (see Appendix)
- **Designate "SSH helpers":** First 3--4 students who get "Hi username!" become roaming helpers. This gives fast students a role and frees you to handle the hard cases

| Minute | What happens | Mode |
|--------|-------------|------|
| 1:18 | **Celebrate:** *"Everyone who sees 'Hi username', make some noise."* | Social |
| 1:19 | **Quiz (workbook 3.3):** *"Which file did you copy --- public or private?"* Quick verbal | Verbal |
| 1:20 | **Checkpoint:** *"SSH is done. You'll never set this up again on this computer."* | Announcement |

---

### Part 4: Push & Clone (1:20--1:30)

**Teaching mode:** Guided, fast-paced. Students are tired --- this needs to be rewarding.

Covers workbook sections 4.1 (Push Your Repository to GitHub), 4.2--4.4 (Clone, Make Changes, Push).

| Minute | What happens | Mode |
|--------|-------------|------|
| 1:20 | Demo creating a repo on GitHub (projector). Emphasize: Public, NO README checkbox | Demo |
| 1:21 | Students create their own GitHub repo | Self-paced |
| 1:22 | Demo `git remote add origin` and `git push -u origin main`. Show the output | Demo |
| 1:23 | Students push | Type-along |
| 1:24 | **The Payoff:** *"Open your repo URL in the browser."* Students see their code on GitHub for the first time | **KEY MOMENT** |
| 1:25 | **Social moment:** *"Paste your GitHub repo URL in the class chat. Visit someone else's repo."* | Social |
| 1:27 | Quick clone exercise: `git clone` their own repo to a new folder, make a change, push, then `git pull` in the original | Fast demo |
| 1:29 | **Final Quiz (workbook 4.1):** *"What did git pull do?"* | Verbal |

---

### Closing (1:30--1:35)

1. **Quick verbal poll:** *"Hardest thing today --- raise your hand: Terminal? Git? SSH?"* (Gives you data for next year)
2. **Preview Week 2:** *"Next week: branches, pull requests, REST APIs. You'll work as a team for the first time."*
3. **Remind about assignment:** *"Create `bme-knowledge-base` repo with 5+ commits. Due before Week 2 lab."*
4. **End-of-lab reflection (workbook):** Either do it verbally in class or assign it for home

---

## Classroom Management Techniques

### 1. "Watch Mode" vs "Type Mode"

Explicitly announce transitions: *"Laptops closed / screens off --- watch me for 2 minutes."* Then: *"OK, now you type."* Students who type while you demo miss the concepts. Students who watch while they should type fall behind.

### 2. The "Stuck" Signal

Give each student a way to signal they need help without raising their hand:

- **Option A:** Red/green sticky notes on laptop lid (green = fine, red = help)
- **Option B:** A Discord/Slack channel where they post screenshots of errors
- **Option C:** Simply say *"If you're stuck, turn to your neighbor first. If BOTH of you are stuck, raise your hand."*

### 3. Fast Finishers

Students who finish early can:

- Help neighbors (designate them as "experts")
- Explore the "How does this actually work?" collapsible sections in the workbook
- Try the stretch tasks: `man ls`, `git log --stat`, explore `.git/` internals
- Start the individual assignment

### 4. Walking the Room

**This is non-negotiable.** During every self-paced section, walk between desks and look at screens. You'll catch:

- Students in the wrong directory (most common)
- Students who haven't typed anything (too shy to ask for help)
- Students typing the wrong command
- Students who are 3 steps ahead (redirect them to help others)

### 5. Energy Dips

The energy will dip around minute 45--50 (middle of Part 2). This is exactly where the commit history exercise lives --- it's self-paced work, which is the right energy level for mid-session. Don't try to lecture here; let them type.

The energy dips again during SSH setup (~minute 70). The "Hi username!" reveal is the natural energy recovery point.

---

## Common Failure Modes & Mitigations

| Failure | Likelihood | Mitigation |
|---------|-----------|------------|
| Students can't install Git (Windows) | HIGH in first offering | Send installation instructions 48h before lab. Have 2--3 USB drives with Git Bash installer |
| SSH blocked by campus network | MEDIUM | Prepare HTTPS fallback instructions (see Appendix). Test SSH from the classroom beforehand |
| Students fall behind in Part 2 | HIGH | The commit exercise (2.8) is designed so Commits 1--5 are copy-paste. Students who fall behind can catch up by copying |
| Student accidentally deletes `.git/` | LOW | Tell them to re-run `git init` and start fresh. Their files are still there |
| GitHub account verification delayed | MEDIUM | Have students create accounts before class (Week 0 prep guide) |
| 90 minutes isn't enough | MEDIUM | Part 4 (push/clone) can be assigned as homework if time runs out. Parts 1--3 are the priority |

---

## End-of-Lab Assessment

### Minimum Completion Checklist

Every student should leave the lab with:

- [ ] Terminal open and basic commands working (`pwd`, `ls`, `cd`, `mkdir`)
- [ ] Git configured with their name and email
- [ ] A local repository with at least 3 commits
- [ ] SSH key generated and added to GitHub
- [ ] At least one successful `ssh -T git@github.com`
- [ ] At least one repository pushed to GitHub

### Quick Verification Method

In the last 2 minutes, ask students to run:

```bash
git log --oneline
```

and

```bash
ssh -T git@github.com
```

Students who see commit history and the GitHub authentication message are good to go.

### For Students Who Didn't Finish

- Reassure them: "You have the workbook. Follow it step by step at home."
- Point them to the Troubleshooting FAQ at the end of the workbook
- Remind them the assignment deadline is before Week 2 lab
- Offer office hours or a communication channel for questions (e.g., Discord, email)

---

## Appendix: Backup HTTPS Instructions

If SSH is blocked by the campus network, students can use HTTPS instead:

### Generate a Personal Access Token

1. Go to GitHub > Settings > Developer settings > Personal access tokens > Tokens (classic)
2. Click "Generate new token (classic)"
3. Set expiration to 90 days
4. Check the `repo` scope
5. Click "Generate token"
6. Copy the token (it will only be shown once!)

### Use HTTPS URLs Instead of SSH

When the workbook says:
```bash
git remote add origin git@github.com:USERNAME/repo.git
```

Use instead:
```bash
git remote add origin https://github.com/USERNAME/repo.git
```

When prompted for a password, use the **Personal Access Token** (not the GitHub password).

### Credential Storage

To avoid typing the token every time:
```bash
git config --global credential.helper store
```

> **Security note:** This stores the token in plaintext on the computer. Fine for lab machines students control, but mention this is not ideal for shared computers.
