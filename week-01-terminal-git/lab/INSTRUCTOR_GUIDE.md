# Week 1 Lab: Instructor Guide

**Course:** Mobile Apps for Healthcare
**Lab Duration:** 2 hours
**Topic:** Terminal, Git & GitHub
**Audience:** 3rd-year Biomedical Engineering students --- zero prior terminal/git experience

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

## Timing Overview

| Time | Duration | Activity | Type |
|------|----------|----------|------|
| 0:00--0:05 | 5 min | Welcome & context setting | Instructor talk |
| 0:05--0:35 | 30 min | Part 1: Terminal basics | Follow-along + exercises |
| 0:35--0:40 | 5 min | Break / catch-up buffer | --- |
| 0:40--1:20 | 40 min | Part 2: Git basics | Follow-along + exercises |
| 1:20--1:25 | 5 min | Break / catch-up buffer | --- |
| 1:25--1:50 | 25 min | Part 3: GitHub & SSH setup | Follow-along |
| 1:50--2:00 | 10 min | Part 4: Clone & push + assignment intro | Follow-along + wrap-up |

**Total:** 120 minutes (2 hours)

> **Pacing note:** The two 5-minute buffers are critical. Use them to help stragglers catch up. If everyone is on track, use the time for Q&A or to reinforce concepts. Never skip the buffers --- someone always needs them.

---

## Detailed Facilitation Guide

### 0:00--0:05 --- Welcome & Context Setting (5 min)

**Type:** Instructor talk

**What to say (talking points, not a script):**

- Welcome to Mobile Apps for Healthcare
- Today's lab: learn the tools that every professional developer uses daily
- "You may feel like you're learning to walk before you can run --- that's intentional"
- This lab comes BEFORE the lecture on purpose: struggle first, understand later
- AI tools are NOT allowed in Weeks 1--3 (explain why: build genuine understanding first)
- The workbook (`README.md`) is your guide --- follow it step by step
- Ask questions at any time. There are no stupid questions, especially today

**What students should be doing:**

- Opening their terminals (help them find it if needed)
- Having the workbook open (on projector or their own screen)

**Checkpoint:** Before moving on, verify that **every student has a terminal open** with a blinking cursor. Walk around the room if necessary.

**Common pitfall:** Windows students may not have Git Bash installed. Identify these students immediately and start the download while you continue talking.

---

### 0:05--0:35 --- Part 1: Terminal Basics (30 min)

**Type:** Follow-along + independent exercises

**Pacing:** This section has 8 subsections. Budget roughly 3--4 minutes per subsection, leaving 5 minutes for the exercise at the end.

#### 0:05--0:08 --- `pwd` (Where Am I?)

**Demo on projector:**
- Type `pwd`, explain the output
- Emphasize: "The terminal is always standing in some folder"
- Show that different OS give different-looking paths

**What to watch for:**
- Students who press Enter before typing the command (nervous clicking)
- Students confused by the prompt itself (they may try to type the `$` or `%`)

**Talking point:** "Think of the terminal as a text-based file explorer. Right now, `pwd` is like looking at the address bar."

#### 0:08--0:12 --- `ls` (What Is Here?)

**Demo:**
- `ls` --- basic listing
- `ls -la` --- all files with details, explain hidden files (dotfiles)

**What to watch for:**
- Windows PowerShell users need `dir` instead (Git Bash users are fine with `ls`)
- Students surprised by hidden files

**Talking point:** "Hidden files start with a dot. They're used for configuration. You'll see `.git` soon --- that's how Git stores everything."

#### 0:12--0:17 --- `cd` (Moving Around)

**Demo the full sequence:**
1. `cd Desktop`
2. `pwd` (show the change)
3. `cd ..` (go back up)
4. `cd ~` (go home)
5. Show an absolute path: `cd /Users/yourname/Documents`

**Have students follow along** --- do each command, wait, check.

**What to watch for:**
- "No such file or directory" errors --- students misspelling folder names
- Students forgetting the space between `cd` and the path
- Tab completion: teach them to press Tab to autocomplete folder names (huge time saver!)

**Talking point:** "Tab completion is your best friend. Start typing a folder name and press Tab. The terminal will complete it for you. If there are multiple matches, press Tab twice to see all options."

#### 0:17--0:20 --- `mkdir` (Creating Folders)

**Demo:**
1. `cd ~`
2. `mkdir mhealth-course`
3. `ls` (show it was created)
4. `cd mhealth-course`
5. `mkdir -p week-01/exercises` (explain the `-p` flag)

**What to watch for:**
- Students creating the folder in the wrong location (remind them to `pwd` first)
- Spaces in folder names cause issues --- tell them to use hyphens instead

#### 0:20--0:24 --- `touch`, `echo`, `cat` (Creating and Viewing Files)

**Demo:**
1. Navigate to `week-01/exercises`
2. `touch notes.txt`
3. `echo "Hello" > notes.txt`
4. `cat notes.txt`
5. `echo "Second line" >> notes.txt`
6. `cat notes.txt`

**Key emphasis:** The difference between `>` (overwrite) and `>>` (append). Demo what happens if you accidentally use `>` when you meant `>>`.

**What to watch for:**
- Students forgetting quotes around the text
- Confusion about `>` vs `>>`

#### 0:24--0:26 --- `rm` (Deleting Files)

**Demo briefly:**
- `rm notes.txt`
- Explain `rm -r` for folders
- **Emphasize strongly:** No trash can, no undo. Permanent deletion.

**Talking point:** "In the GUI, you can drag to Trash and recover. In the terminal, `rm` is permanent. Always double-check. If you're not sure, use `ls` first to see what you're about to delete."

#### 0:26--0:28 --- `which` (Finding Programs)

**Demo:**
- `which git`
- `which python3`
- Brief explanation of PATH (don't go deep --- the workbook has a conceptual box)

#### 0:28--0:35 --- Exercise 1.8 (Build a Project Structure)

**Switch to independent work.** Say: "Now it's your turn. Follow Exercise 1.8 in the workbook. You have 7 minutes. Raise your hand if you get stuck."

**Walk around the room.** Common issues:
- Students creating folders in the wrong place (remind them to `pwd`)
- Forgetting to create nested directories with `-p`
- Not knowing how to write multiple lines to a file

**Checkpoint:** Before moving on, ask: "Who can show me the output of `ls -R` from their `mhealth-course` folder?" Pick a student to show on projector or read aloud.

**Recovery if behind:** If many students are struggling, do the exercise together as a class. Speed is less important than understanding.

---

### 0:35--0:40 --- Break / Catch-Up Buffer (5 min)

- Students who finished the exercise: take a real break
- Students who are behind: use this time to catch up
- Walk around and verify everyone has the `mhealth-course` folder structure
- Answer individual questions
- If everyone is done, use this time to reinforce: "What does `cd ..` do? What's the difference between `>` and `>>`?"

---

### 0:40--1:20 --- Part 2: Git Basics (40 min)

**Type:** Follow-along + exercises

**This is the core of the lab.** Students must leave understanding `init`, `add`, `commit`, `status`, `log`, and `diff`.

#### 0:40--0:43 --- What Is Git? + Configuration (3 min)

**Talking points:**
- "Git is like unlimited undo for your entire project"
- "It tracks every change --- who made it, when, and why"
- "You will use this every single day as a professional developer"

**Demo git config:**
```bash
git config --global user.name "Your Full Name"
git config --global user.email "your.email@student.agh.edu.pl"
```

**Have every student run these commands** with their own name and email.

**What to watch for:**
- Students forgetting quotes around their name
- Students using a non-student email (remind them to use AGH email)

#### 0:43--0:48 --- `git init` + `git status` (5 min)

**Demo:**
1. `cd ~/mhealth-course && mkdir my-first-repo && cd my-first-repo`
2. `git init`
3. `ls -la` (show the hidden `.git` directory)
4. `git status`

**Talking point:** "The `.git` folder is where Git stores everything. Never delete it, never edit it manually. As far as you're concerned, it's magic --- and we'll peek inside later."

**What to watch for:**
- Students who see `master` instead of `main` (both are fine, explain this)
- Students who accidentally init git in the wrong folder (home directory, Desktop, etc.)

**Recovery:** If a student inits in the wrong place, show them `rm -r .git` to undo it, then `cd` to the right folder.

#### 0:48--1:00 --- First Commit Cycle (12 min)

**This is the most important part of the lab.** Go slowly.

**Demo the full cycle step by step:**

1. Create `README.md` with `echo`
2. `git status` --- show "Untracked files" in red
3. `git add README.md`
4. `git status` --- show "Changes to be committed" in green
5. `git commit -m "Add initial README with project description"`
6. `git status` --- show "nothing to commit, working tree clean"
7. `git log` --- show the commit

**Pause after each step.** Ask: "What color are the files? What does that mean?"

**Key teaching moment:** The three areas of Git.

Draw on the whiteboard (or point to the ASCII diagram in the workbook):
```
Working Directory  -->  Staging Area  -->  Repository
(your files)           (git add)          (git commit)
```

**Analogy:** "Think of it like packing a box to ship. Your working directory is your room --- stuff is scattered around. `git add` puts items into the box (staging). `git commit` seals the box, labels it, and puts it on the shelf (repository). You can only ship what's in the box."

**What to watch for:**
- Students skipping `git add` and going straight to `git commit`
- Students confused about why staging exists ("Why can't I just commit directly?")
  - Answer: "Staging lets you choose exactly what goes into each commit. You might have changed 5 files but only want to commit 2 of them."

#### 1:00--1:05 --- `git log` and `git diff` (5 min)

**Demo:**
1. Modify `README.md` with `echo "## Topics" >> README.md`
2. `git diff` --- show the `+` lines
3. `git add README.md && git commit -m "Add Topics section"`
4. `git log --oneline` --- show compact history

**Talking point:** "`git diff` is your pre-commit review. Always check what you're about to commit. It's like proofreading before hitting Send."

#### 1:05--1:20 --- Exercise 2.8: Build a Commit History (15 min)

**Switch to guided independent work.** Students follow the exercise in the workbook to make 5 commits.

**Say:** "Work through the exercise in the workbook. You have 15 minutes. The goal is to have at least 5 commits when you run `git log --oneline`. Raise your hand if you need help."

**Walk around actively.** This is where most students get stuck.

**Common issues:**
- Forgetting `git add` before `git commit` --- the commit will be empty or fail
- Making all commits at once without actually editing files between commits
- Typos in commit messages (it's fine, don't worry about fixing them)
- Students who race ahead vs students who fall behind

**For fast students:** Suggest they explore `git log --oneline --graph` or try modifying files and using `git diff` before committing.

**Checkpoint:** "Show me your `git log --oneline`. Do you have at least 5 commits?" Aim for 80%+ of students completing this.

**Recovery if behind:** If many students are stuck, do commits 3--5 together as a class on the projector.

---

### 1:20--1:25 --- Break / Catch-Up Buffer (5 min)

- Same as the first break
- Priority: make sure every student has a working git repo with at least a few commits
- Students who are ahead can read the "How does this work?" boxes in the workbook
- Quick check: "How many of you have 5+ commits? How many have 3+? How many have at least 1?"

---

### 1:25--1:50 --- Part 3: GitHub & SSH Setup (25 min)

**Type:** Follow-along (everyone does it together, step by step)

**This section requires patience.** SSH setup is where things go wrong most often.

#### 1:25--1:28 --- GitHub Account Creation (3 min)

**Say:** "If you don't have a GitHub account, create one now. Use your AGH student email. Choose a professional username --- you might put this on your CV."

**Most students may already have accounts.** Use this time for those who don't.

**What to watch for:**
- Students choosing unprofessional usernames (gently suggest they reconsider)
- Email verification delays

#### 1:28--1:38 --- SSH Key Generation (10 min)

**This is the most error-prone section. Go very slowly.**

**Demo on projector:**

1. `ssh-keygen -t ed25519 -C "your.email@student.agh.edu.pl"`
2. Press Enter for default file location
3. Press Enter twice for no passphrase (explain this is fine for the course)
4. Show the output, point out the two files created

**Then copy the public key:**
- macOS: `cat ~/.ssh/id_ed25519.pub | pbcopy`
- Windows Git Bash: `cat ~/.ssh/id_ed25519.pub | clip`
- Fallback: `cat ~/.ssh/id_ed25519.pub` and copy manually

**Key emphasis:** "You have TWO files. The `.pub` file is your PUBLIC key --- share it freely. The other file is your PRIVATE key --- never share it, never email it, never upload it."

**What to watch for:**
- Students who already have SSH keys: that's fine, they can use existing ones or generate new ones
- Students who set a passphrase and then forget it: for the course, no passphrase is fine
- Students who copy the private key instead of the public key (the private key does NOT end in `.pub`)
- Windows students who can't find the `.ssh` folder (it's hidden --- use `ls -la ~` or `cat ~/.ssh/id_ed25519.pub`)
- Students on older systems where ed25519 is not supported: fall back to `ssh-keygen -t rsa -b 4096`

#### 1:38--1:43 --- Add Key to GitHub (5 min)

**Demo on projector with your browser:**
1. GitHub > Settings > SSH and GPG keys > New SSH key
2. Title: "Lab Computer" (or similar)
3. Paste the public key
4. Click "Add SSH key"

**Have students follow along.** Walk around to help.

**What to watch for:**
- Students pasting the key incorrectly (extra spaces, missing characters)
- Students who can't find the Settings page

#### 1:43--1:50 --- Test Connection (7 min)

**Demo:**
```bash
ssh -T git@github.com
```

**Expected:** "Hi username! You've successfully authenticated..."

**Type `yes`** when asked about the host fingerprint. Explain: "This is your computer learning to trust GitHub. You only need to do this once."

**Troubleshooting (have these ready):**

| Problem | Solution |
|---------|----------|
| "Permission denied (publickey)" | Key not added correctly. Re-copy `.pub` file, re-add to GitHub |
| "Connection timed out" | SSH blocked by network. Switch to HTTPS (see backup instructions) |
| "Could not resolve hostname" | Network/DNS issue. Check internet connection |
| Students already set up | Have them help a neighbor |

**HTTPS Backup Plan:**

If SSH is blocked by the lab network:
1. On GitHub, use "HTTPS" clone URLs instead of "SSH"
2. Create a Personal Access Token: GitHub > Settings > Developer settings > Personal access tokens > Generate new token
3. Use the token as the password when prompted
4. This is a workaround --- encourage students to set up SSH at home

**Checkpoint:** "Raise your hand if you see the 'successfully authenticated' message." Aim for 90%+. Help remaining students individually.

---

### 1:50--2:00 --- Part 4: Clone & Push + Assignment Intro (10 min)

**Type:** Follow-along + wrap-up

#### 1:50--1:55 --- Push Existing Repository (5 min)

**Demo on projector:**

1. Create a new repo on GitHub (show the web interface)
2. Name it `my-first-repo`, leave it empty (no README)
3. In terminal:
   ```bash
   cd ~/mhealth-course/my-first-repo
   git remote add origin git@github.com:YOUR-USERNAME/my-first-repo.git
   git push -u origin main
   ```
4. Refresh the GitHub page --- show files and commits appearing

**What students should do:** Follow along and push their own `my-first-repo`.

**What to watch for:**
- "remote origin already exists" --- `git remote remove origin` and re-add
- Branch name mismatch (`master` vs `main`) --- use whichever they have
- Students who didn't finish Part 2 exercises: that's OK, they can push whatever they have

#### 1:55--2:00 --- Assignment Introduction (5 min)

**Talking points:**
- Walk through the individual assignment in the workbook
- Emphasize: 5 meaningful commits, 3+ files, push to GitHub
- Deadline: before Week 2 lab
- "This is individual work. No AI tools. The point is to practice what you learned today."
- Show the grading rubric briefly

**Final words:**
- "You just learned the tools that every software developer uses daily"
- "It feels awkward now --- that's normal. By week 4, this will be second nature"
- "If you get stuck on the assignment, re-read the workbook. Everything you need is there."
- "The lecture will explain the theory behind what you just did. See you there."

---

## Instructor Notes: Pacing & Common Issues

### Where Students Typically Get Stuck

1. **Terminal is intimidating.** The blank screen with a cursor is scary for students who have only used GUIs. Normalize this: "Everyone feels this way. It's like learning a new language."

2. **Forgetting `git add`.** This is the #1 mistake in Part 2. Every time you demo, always show the full cycle: `git status` -> `git add` -> `git status` -> `git commit` -> `git status`.

3. **SSH key setup.** This is the #1 time sink. Budget extra time here. Consider having a TA or advanced student help with troubleshooting.

4. **Confusing the terminal with a search bar.** Some students will try to type full sentences or questions into the terminal. Gently redirect.

5. **Typos.** Students who are not touch-typists will make many typos. Teach them about the **up arrow** (to repeat the last command) and **Tab completion** early.

### Where to Slow Down

- The first `git add` / `git commit` cycle. Do it slowly, explain every output.
- SSH key generation. Don't rush this --- one mistake means debugging later.
- The difference between `>` and `>>`.

### Where You Can Speed Up

- `which` command (students don't need to fully grasp PATH today)
- `rm` / `rmdir` (brief warning is enough)
- GitHub account creation (most students already have one)

### If You're Running Out of Time

Priority order (must complete):
1. Terminal basics (pwd, ls, cd, mkdir, touch/echo/cat) --- students need these for everything else
2. Git init, add, commit, status, log --- the core workflow
3. SSH setup + push to GitHub --- needed for the assignment

Can be shortened:
- Exercise 1.8 (can be homework)
- Exercise 2.8 (can reduce from 5 commits to 3)
- `git diff` explanation (nice to have, not essential)
- `which` command (skip if pressed for time)

### If You Have Extra Time

- Show `git log --oneline --graph --all` and explain the output
- Explore the `.git` directory together (`ls .git`, explain objects/refs briefly)
- Demo `git stash` briefly as a preview
- Have students clone each other's repositories and look at the commit history
- Discuss what makes a good vs bad commit history

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
