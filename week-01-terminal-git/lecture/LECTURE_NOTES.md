# Week 1 Lecture: Terminal, Git & GitHub --- How It All Works

**Course:** Mobile Apps for Healthcare
**Duration:** ~2 hours (including Q&A)
**Format:** Student-facing notes with presenter cues

> Lines marked with `> PRESENTER NOTE:` are for the instructor only. Students can
> ignore these or treat them as bonus context.

---

## Table of Contents

1. [The Missing Semester](#1-the-missing-semester-20-min) (20 min)
2. [How Git Actually Works](#2-how-git-actually-works-30-min) (30 min)
3. [How SSH & Cryptographic Keys Work](#3-how-ssh--cryptographic-keys-work-20-min) (20 min)
4. [How Software Teams Actually Work](#4-how-software-teams-actually-work-15-min) (15 min)
5. [The Mood Tracker Vision](#5-the-mood-tracker-vision-10-min) (10 min)
6. [Course Overview](#6-course-overview-5-min) (5 min)

---

## 1. The Missing Semester (20 min)

### What You Don't Learn in Most CS/BME Programs

University courses teach you algorithms, data structures, signal processing, biomechanics. But they rarely teach you the **tools** that professional developers use every single day:

- The terminal / command line
- Version control (Git)
- Collaboration workflows (GitHub, code review)
- Debugging and testing strategies
- Build systems and deployment

These are the "missing semester" --- the skills that everyone assumes you already know when you start your first job or research position.

> PRESENTER NOTE: Ask the audience: "How many of you have used the terminal before
> today's lab?" and "How many of you have heard of Git?" Get a sense of the room.

### The Iceberg of Professional Software Development

What you see when you look at a finished app is just the tip of the iceberg:

```d2
direction: down

visible: "What Users See" {
  style.fill: "#E3F2FD"
  style.font-size: 20
  app: "Beautiful working app"
}

surface: "" {
  style.stroke-dash: 5
  style.fill: "transparent"
  label: "~~ surface ~~"
}

hidden: "What Actually Makes the App Possible" {
  style.fill: "#FFF3E0"
  style.font-size: 20
  vc: "Version control"
  testing: "Testing"
  review: "Code review"
  cicd: "CI/CD pipelines"
  docs: "Documentation"
  deps: "Dependency management"
  security: "Security practices"
  debug: "Debugging tools"
  deploy: "Deployment"
  monitoring: "Monitoring"
  team: "Team coordination"
}

visible -> hidden: {style.stroke-dash: 3}
```

This course teaches you both halves: the visible app (Flutter, APIs) AND the invisible infrastructure (Git, testing, CI/CD, team workflows).

### Horror Stories: What Happens Without Version Control

#### The "Final Version" Problem

Everyone has done this:

```
report.docx
report_v2.docx
report_v2_final.docx
report_v2_final_REAL.docx
report_v2_final_REAL_submitted.docx
report_v2_final_REAL_submitted_fixed.docx
```

Which one is actually the latest? Which one was submitted? What changed between versions? Nobody knows.

> PRESENTER NOTE: Open a file explorer and show a messy Desktop or folder with
> "final_v2_REAL" files. Students will laugh and recognize this pattern. If you
> have a real example from your own work, even better.

#### The "Someone Overwrote My Work" Problem

Scenario: Two students are working on the same project. Both download the file from a shared drive, make changes independently, and upload their version. The second upload **overwrites** the first. The first student's work is gone.

With version control, this cannot happen. Git detects conflicts and forces you to resolve them explicitly.

#### The "We Can't Reproduce the Results" Problem

This one is particularly relevant to **biomedical research**:

- A researcher publishes a paper with computational results
- Another lab tries to reproduce the results but gets different numbers
- The original researcher cannot figure out which version of their code produced the published results
- The paper's credibility is damaged

With Git, every version of the code is preserved. You can always go back to the exact code that produced specific results. This is why an increasing number of journals now require code repositories.

### Why This Matters in Healthcare

Healthcare software has higher stakes than most software:

- **Traceability:** Regulators need to know exactly what code is running on a medical device. "Some version of the software" is not acceptable.
- **Reproducibility:** Clinical trials involve software for data analysis. If you cannot reproduce the analysis, the trial results are questionable.
- **Audit trails:** Who changed what, when, and why? Git provides this automatically.
- **Patient safety:** A bug in a healthcare app can harm patients. Version control helps you track down when bugs were introduced and revert them quickly.

You are not just learning tools for convenience. In healthcare, these practices are **regulatory requirements**.

> PRESENTER NOTE: Mention IEC 62304 (medical device software lifecycle standard)
> briefly. Don't go deep --- just plant the seed that version control is not optional
> in medical software development. We'll revisit this in later weeks.

---

## 2. How Git Actually Works (30 min)

In the lab, you learned the commands: `git add`, `git commit`, `git push`. Now let's understand what is actually happening behind the scenes.

### Snapshots, Not Diffs

Many people think Git stores the **changes** (diffs) between versions. It does not. Git stores **complete snapshots** of your project at each commit.

```d2
direction: right

a: "Commit A\n(initial)" {
  style.fill: "#E3F2FD"
  a1: "README.md (v1)"
  a2: "app.py (v1)"
}

b: "Commit B\n(add feature)" {
  style.fill: "#E3F2FD"
  b1: "README.md (v1)"
  b2: "app.py (v2)"
  b3: "test.py (v1)"
}

c: "Commit C\n(fix bug)" {
  style.fill: "#E3F2FD"
  c1: "README.md (v2)"
  c2: "app.py (v2)"
  c3: "test.py (v1)"
}

a -> b -> c: "parent"
```

**Analogy:** Each commit is like a **photograph** of your entire project at that moment. You are not recording "what changed" --- you are taking a full snapshot. To see what changed, Git compares two snapshots.

> In practice, Git is smart about storage. If a file did not change between commits,
> Git reuses the previous version instead of storing a duplicate copy. So it stores
> snapshots conceptually but is efficient about disk space.

> PRESENTER NOTE: This is a common misconception. Many students (and professionals!)
> think Git stores diffs. Emphasize the snapshot model --- it makes branching and merging
> much easier to understand later.

### The Three Areas --- Revisited

You practiced this in the lab. Now let's go deeper:

```d2
direction: right

working: "WORKING\nDIRECTORY" {
  style.fill: "#E3F2FD"
  label: "WORKING DIRECTORY"
  desc: |md
    Your files as you see them
    in Finder/Explorer.
    You edit these files freely.
  |
}

staging: "STAGING AREA\n(Index)" {
  style.fill: "#FFF9C4"
  label: "STAGING AREA (Index)"
  desc: |md
    A preview of what your next
    commit will look like.
    "Shopping cart" — you can add
    and remove items before checkout.
  |
}

repo: "REPOSITORY\n(.git directory)" {
  style.fill: "#E8F5E9"
  label: "REPOSITORY (.git directory)"
  desc: |md
    Permanent, immutable history
    of your project.
    Each commit is a snapshot,
    frozen in time.
  |
}

working -> staging: "git add"
staging -> working: "git restore" {style.stroke-dash: 3}
staging -> repo: "git commit"
```

**Why does the staging area exist?** It gives you fine-grained control. Real-world example:

You are fixing a bug, and while doing so, you notice a typo in a comment. You fix both. But these are two different logical changes. With the staging area, you can:

1. `git add bug-fix-file.py` --- stage only the bug fix
2. `git commit -m "Fix temperature unit conversion bug"`
3. `git add comment-file.py` --- stage only the typo fix
4. `git commit -m "Fix typo in measurement module comment"`

Two clean, focused commits from one editing session.

> PRESENTER NOTE: Demo this scenario live if time allows. Create a file, make two
> unrelated changes, and show how to commit them separately using selective `git add`.

### Commit Hashing --- Every Commit Has a Fingerprint

Every commit in Git has a unique identifier called a **SHA-1 hash**. It looks like this:

```
a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6q7r8s9t0
```

Or in short form (first 7 characters):

```
a1b2c3d
```

This hash is computed from:
- The contents of all files in the snapshot
- The author name and email
- The timestamp
- The commit message
- The hash of the parent commit(s)

**Analogy: A fingerprint that verifies integrity**

Think of the hash like a fingerprint:
- It is **unique** --- no two different commits will ever have the same hash
- It is **deterministic** --- the same content always produces the same hash
- It is **tamper-evident** --- if anyone changes even a single character in the commit, the hash completely changes

This matters in healthcare: Git's commit hashes provide a built-in **integrity guarantee**. If someone tampers with the code history, the hashes will break, and everyone will know. This is crucial for regulated environments where you need to prove that your code has not been modified without authorization.

```d2
direction: right

c1: "a1b2c3d" {
  style.fill: "#E3F2FD"
  label: |md
    **a1b2c3d**
    "Initial README"
  |
}

c2: "f4e5d6c" {
  style.fill: "#E3F2FD"
  label: |md
    **f4e5d6c**
    "Add feature"
  |
}

c3: "b7a8c9d" {
  style.fill: "#E3F2FD"
  label: |md
    **b7a8c9d**
    "Fix bug"
  |
}

c3 -> c2: "" {style.stroke: "#666"}
c2 -> c1: "" {style.stroke: "#666"}
```

Each commit points back to its parent. The hash of each commit depends on its parent's hash, creating an unbreakable chain. Change any commit, and all subsequent hashes change too.

> PRESENTER NOTE: If students ask about SHA-1 collisions, briefly mention that Git is
> transitioning to SHA-256, but SHA-1 collisions are not a practical concern for version
> control (they are for cryptographic signing). Don't go deep into this.

### Branches Are Just Pointers

A branch in Git is **not** a copy of your project. It is just a lightweight label (a pointer) that points to a specific commit.

```
                        main
                          |
                          v
  [Commit A] <── [Commit B] <── [Commit C]
```

When you make a new commit on `main`, the pointer moves forward:

```
                                   main
                                     |
                                     v
  [Commit A] <── [Commit B] <── [Commit C] <── [Commit D]
```

Creating a new branch just creates a new pointer:

```d2
direction: right

a: "[Commit A]"
b: "[Commit B]"
c: "[Commit C]"
d: "[Commit D]"

a <- b <- c <- d

main: "main" {
  style.fill: "#C8E6C9"
  style.font-size: 18
  style.bold: true
}
feature: "feature" {
  style.fill: "#BBDEFB"
  style.font-size: 18
  style.bold: true
}

main -> d: {style.stroke-dash: 3}
feature -> c: {style.stroke-dash: 3}
```

If you switch to `feature` and make a new commit:

```d2
direction: right

a: "[Commit A]"
b: "[Commit B]"
c: "[Commit C]"
d: "[Commit D]"
e: "[Commit E]"

a <- b <- c
c <- d
c <- e

main: "main" {
  style.fill: "#C8E6C9"
  style.bold: true
}
feature: "feature" {
  style.fill: "#BBDEFB"
  style.bold: true
}

main -> d: {style.stroke-dash: 3}
feature -> e: {style.stroke-dash: 3}
```

Now `main` and `feature` have diverged. We will learn how to merge them in Week 2.

> **Key insight:** Creating a branch is nearly free in Git. It is just writing a 40-character
> hash to a file. This is why Git encourages branching --- unlike older version control
> systems where creating a branch meant copying the entire project.

### HEAD --- "You Are Here"

`HEAD` is a special pointer that tells Git which branch (and therefore which commit) you are currently working on. Think of it as the "you are here" marker on a map.

```
                                   HEAD
                                     |
                                     v
                                   main
                                     |
                                     v
  [Commit A] <── [Commit B] <── [Commit C]
```

When you switch branches with `git checkout feature` (or `git switch feature`), HEAD moves:

```d2
direction: right

a: "[A]"
b: "[B]"
c: "[C]"
d: "[D]"
e: "[E]"

a <- b <- c
c <- d <- e

main: "main" {
  style.fill: "#C8E6C9"
  style.bold: true
}
head: "HEAD" {
  style.fill: "#FFCDD2"
  style.bold: true
}
feature_label: "feature" {
  style.fill: "#BBDEFB"
  style.bold: true
}

main -> c: {style.stroke-dash: 3}
head -> feature_label: {style.stroke-dash: 3}
feature_label -> e: {style.stroke-dash: 3}
```

> PRESENTER NOTE: Open a terminal and show `.git/HEAD`:
> ```bash
> cat .git/HEAD
> ```
> It will show something like `ref: refs/heads/main`. Then show:
> ```bash
> cat .git/refs/heads/main
> ```
> It will show the commit hash. This makes branches concrete --- they are literally
> just text files containing a hash.

### Putting It All Together

Here is the complete mental model of how Git works:

```d2
direction: down

project: "YOUR PROJECT" {
  style.fill: "#F5F5F5"

  direction: right

  working: "Working Directory" {
    style.fill: "#E3F2FD"
    desc: "Files you edit daily"
  }

  staging: "Staging Area" {
    style.fill: "#FFF9C4"
    desc: "Next commit preview"
  }

  repo: "Repository" {
    style.fill: "#E8F5E9"
    desc: "Permanent history"
  }

  working -> staging: "add"
  staging -> repo: "commit"

  repo -> remote: "push"

  remote: "Remote repo\n(GitHub)" {
    style.fill: "#F3E5F5"
  }

  notes: |md
    **Branches:** lightweight pointers to commits
    **HEAD:** points to your current branch
    **Commits:** snapshots with unique hash fingerprints
  |
}
```

---

## 3. How SSH & Cryptographic Keys Work (20 min)

### The Problem

You want to push code to GitHub. GitHub needs to know that it is really **you** and not someone pretending to be you. But sending your password over the internet every time is:

1. **Annoying** --- you have to type it constantly
2. **Risky** --- passwords can be intercepted
3. **Weak** --- passwords can be guessed

SSH keys solve all three problems.

### Symmetric vs Asymmetric Encryption

Before we talk about SSH keys, we need to understand two types of encryption.

#### Symmetric Encryption: One Key for Everything

```d2
direction: down

title: "SYMMETRIC ENCRYPTION" {
  style.fill: "#FFF3E0"
  style.font-size: 22
  style.bold: true

  subtitle: "Same key locks AND unlocks"

  direction: right

  encrypt: {
    direction: right
    plain1: "Hello"
    cipher1: "x8#kQ2m!"
    plain1 -> cipher1: "lock (key A)" {style.stroke: "#E65100"}
  }

  decrypt: {
    direction: right
    cipher2: "x8#kQ2m!"
    plain2: "Hello"
    cipher2 -> plain2: "unlock (key A)" {style.stroke: "#2E7D32"}
  }

  analogy: |md
    **Analogy:** A house key.
    The same key locks and unlocks the door.

    **Problem:** How do you safely give the key
    to someone far away?
  |
}
```

Symmetric encryption is fast and simple, but it has a fundamental problem: you need to somehow share the secret key with the other person. If you send the key over the internet, someone could steal it.

#### Asymmetric Encryption: Two Keys Working Together

```d2
direction: down

title: "ASYMMETRIC ENCRYPTION" {
  style.fill: "#E8F5E9"
  style.font-size: 22
  style.bold: true

  subtitle: "Two different keys: one LOCKS, the other UNLOCKS"

  direction: right

  public_key: "PUBLIC KEY" {
    style.fill: "#BBDEFB"
    share: "Share with everyone"
    can_do: |md
      Can LOCK (encrypt)
      Can VERIFY signatures
    |
  }

  private_key: "PRIVATE KEY" {
    style.fill: "#FFCDD2"
    keep: "Keep SECRET forever"
    can_do: |md
      Can UNLOCK (decrypt)
      Can CREATE signatures
    |
  }

  analogy: |md
    **Analogy:** You manufacture 100 identical
    PADLOCKS and give them to anyone who wants one.
    Only YOU keep the KEY.

    Anyone can snap a padlock shut on a message
    for you, but only you can open it.
  |
}
```

Asymmetric encryption solves the key-sharing problem: you freely share your public key, and keep your private key secret. No secret needs to travel over the internet.

> PRESENTER NOTE: This is one of the most elegant ideas in computer science. Pause and
> let it sink in. Ask: "How is this possible? How can one key lock and a different key
> unlock?" You don't need to explain the math (RSA, elliptic curves). Just emphasize
> that it works because of mathematical relationships between the two keys.

### How SSH Authentication Actually Works

When you run `ssh -T git@github.com`, here is what happens step by step:

```d2
shape: sequence_diagram

your_computer: "Your Computer\n(has private key)"
github: "GitHub Server\n(has your public key)"

your_computer -> github: "1. Hello, I'm user X"
github -> your_computer: "2. Prove it. Sign this challenge: 7f3a..."
your_computer -> github: "3. Here's my signature: 9d2b..."
your_computer."Signs challenge with private key"
github."Verifies signature with public key"
github -> your_computer: "4. Signature valid! Welcome, user X."
```

**Step by step:**

1. Your computer says: "I want to log in as user X"
2. GitHub generates a random challenge (a string of random data) and sends it to your computer
3. Your computer **signs** the challenge with your **private key** and sends the signature back
4. GitHub uses your **public key** (which you uploaded to GitHub Settings) to **verify** the signature
5. If the signature is valid, GitHub knows you are who you claim to be --- only someone with the private key could have produced that signature

**Why is this secure?**
- The private key **never leaves your computer**
- The challenge is random every time, so a recorded signature cannot be replayed
- Even if someone intercepts the signature, they cannot use it again (it only works for that specific challenge)

### ED25519 vs RSA

When you generated your SSH key, you used `ssh-keygen -t ed25519`. You might have seen RSA mentioned elsewhere. Here is the brief comparison:

| | ED25519 | RSA |
|---|---|---|
| Algorithm | Elliptic curve | Prime factorization |
| Key size | 256 bits | 2048--4096 bits |
| Speed | Faster | Slower |
| Security | Equally strong | Equally strong |
| Key length | Shorter, cleaner | Longer |
| Recommendation | **Use this** | Fine, but ED25519 is preferred |

Both are secure. ED25519 is newer, produces shorter keys, and is faster. That is why we used it.

> PRESENTER NOTE: If students ask "but isn't a bigger key more secure?", explain that
> elliptic curve cryptography achieves the same security level with much smaller keys
> because the underlying math problem is harder to solve. A 256-bit ED25519 key is
> roughly as secure as a 3072-bit RSA key.

### Why "Never Share Your Private Key"

Your private key is your **digital identity**. Consider what happens if someone obtains it:

```
Scenario: Alice's private key is stolen by Eve

Eve (attacker):
  1. Connects to GitHub: "I'm Alice"
  2. Gets challenge from GitHub
  3. Signs with Alice's private key ← Eve has this now
  4. GitHub: "Welcome, Alice!"

Eve can now:
  - Push code to Alice's repositories
  - Delete Alice's repositories
  - Access Alice's private repositories
  - Impersonate Alice in any system that uses this key

Alice has NO way to know this is happening until she notices
unauthorized changes.
```

**Protect your private key like a password --- actually, more than a password.** A password can be changed. If your private key is compromised, you need to:
1. Remove the public key from every service that has it
2. Generate a brand new key pair
3. Re-add the new public key everywhere

> PRESENTER NOTE: Demo `~/.ssh/` contents. `cat` the public key and explain each part:
> ```
> ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAI... user@email.com
> ^^^^^^^^^^^  ^^^^^^^^^^^^^^^^^^^^^^^^     ^^^^^^^^^^^^^
> algorithm    the actual key (base64)      comment (your email)
> ```
> Point out that the private key file has no `.pub` extension and should have
> permissions `600` (owner read/write only).

---

## 4. How Software Teams Actually Work (15 min)

### Solo vs Team Development

So far, you have been working alone:

```
Solo workflow:

  You ──> edit ──> add ──> commit ──> push ──> done
```

This is fine for homework. But real-world software is built by teams of 2 to 2,000 people working on the same codebase simultaneously.

What happens when multiple people edit the same file? How do you review each other's work? How do you ensure quality? This is where Git's features truly shine.

### The Branch-Based Workflow

In professional teams, no one pushes directly to `main`. Instead:

```d2
direction: right

a: "[A]" {style.fill: "#E8F5E9"}
b: "[B]" {style.fill: "#E8F5E9"}
c: "[C]" {style.fill: "#BBDEFB"}
d: "[D]" {style.fill: "#BBDEFB"}
e: "[E]" {style.fill: "#BBDEFB"}
f: "[F]" {style.fill: "#E8F5E9"}

a -> b: "main"
b -> c: ""
c -> d: "feature-x"
d -> e: ""
e -> f: "merge"
b -> f: "main" {style.stroke-dash: 5}

pr: "Pull Request\n+ Code Review" {
  style.fill: "#FFF9C4"
  style.font-size: 14
  style.bold: true
}
pr -> d: {style.stroke-dash: 3}
```

**The workflow:**

1. **Branch:** Create a new branch from `main` for your feature or bug fix
2. **Code:** Make your changes on the branch (multiple commits)
3. **Pull Request (PR):** When done, open a PR on GitHub --- "I'd like to merge my changes into main"
4. **Review:** Your teammates review your code, leave comments, suggest improvements
5. **Merge:** Once approved, the branch is merged into `main`

**Why this matters:**

- **Parallel work:** Multiple people can work on different features simultaneously without interfering with each other
- **Code review:** Every change is reviewed before it enters the main codebase --- catches bugs, enforces standards
- **Safe experimentation:** If a feature branch breaks things, `main` is unaffected
- **History:** Each feature/fix is a clear unit in the git history

> PRESENTER NOTE: Open a real open-source project on GitHub (e.g., any popular health-tech
> repo). Show the branches, the PRs, the code review comments. Let students see what
> professional collaboration looks like.

### A Typical Day on a Software Team

Here is what a developer's day might look like:

```
Morning:
  1. git pull                    ← Get latest changes from team
  2. git checkout -b fix-login   ← Start working on a task
  3. (write code, test it)
  4. git add + commit             ← Save progress locally
  5. git push                    ← Share with team
  6. Open PR on GitHub           ← Request review

Afternoon:
  7. Review a teammate's PR      ← Read their code, leave feedback
  8. Address review comments     ← Update your own PR based on feedback
  9. Merge PR                    ← Feature is now in main
  10. git checkout main && git pull  ← Get the merged changes
  11. Start next task            ← Repeat
```

You will practice this workflow starting in Week 2.

### Why Healthcare Teams Need This Even More

Regular software teams use these practices for quality. Healthcare software teams use them because they are **required by regulation**:

| Regulatory Requirement | How Git/GitHub Helps |
|---|---|
| **Traceability** (IEC 62304) | Every change has a commit with author, date, and reason |
| **Change control** | Pull requests require review before merging |
| **Audit trails** | Git log provides a complete, tamper-evident history |
| **Reproducibility** | Tags and branches mark exactly which code was released |
| **Defect tracking** | GitHub Issues link directly to the code changes that fix them |

> PRESENTER NOTE: You don't need to go deep into IEC 62304 or FDA regulations. The point
> is: in healthcare, version control and code review are not just "nice to have" ---
> they are legally required. Students who learn these practices now will be ahead of
> their peers in the job market.

### Code Review: What Does It Look Like?

When someone opens a Pull Request, reviewers can:

```
┌─────────────────────────────────────────────────────────┐
│  Pull Request #42: Fix heart rate calculation           │
│  Author: jan-kowalski    Reviewers: anna-nowak          │
│                                                         │
│  Files changed: 2    Commits: 3    Comments: 5          │
├─────────────────────────────────────────────────────────┤
│                                                         │
│  heart_rate.py                                          │
│                                                         │
│  - def calculate_bpm(intervals):                        │
│  -     return 60 / mean(intervals)                      │
│  + def calculate_bpm(rr_intervals_ms):                  │
│  +     rr_seconds = [i / 1000 for i in rr_intervals_ms]│
│  +     return 60 / mean(rr_seconds)                     │
│                                                         │
│  💬 anna-nowak: "Good catch on the unit conversion!     │
│     But should we add a check for empty lists?"         │
│                                                         │
│  💬 jan-kowalski: "Good point, added in next commit."   │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

Code review catches bugs, improves code quality, and spreads knowledge across the team. It is one of the most valuable practices in software engineering.

---

## 5. The Mood Tracker Vision (10 min)

### What We're Building Over 14 Weeks

Over the next 14 weeks, you will build a complete **mood tracking application** --- from a mobile app (Flutter) to a backend API (FastAPI) to deployment.

> PRESENTER NOTE: Have the mood tracker app running on an emulator or physical device.
> Walk through the screens live. Show:
> - The mood logging screen (select mood, add notes)
> - The history/calendar view
> - The data visualization (charts over time)
> - The settings screen
> Then briefly show the codebase and the git history. "All of this is tracked in Git.
> You can see every feature being added, commit by commit."

### The Stack

```d2
direction: down

mobile: "Mobile App (Flutter/Dart)" {
  style.fill: "#E3F2FD"
  ui: "UI screens (mood input, history, charts)"
  storage: "Local storage (SQLite)"
  client: "API client"
}

backend: "Backend API (FastAPI/Python)" {
  style.fill: "#E8F5E9"
  auth: "Authentication"
  validation: "Data validation"
  db: "Database (PostgreSQL)"
}

infra: "Infrastructure" {
  style.fill: "#FFF3E0"
  git: "Git + GitHub (version control)"
  cicd: "CI/CD (automated testing + deployment)"
  docker: "Docker (containerization)"
}

mobile -> backend: "HTTP/REST"
```

### From Zero to Shipped

```
Week 1:  You are here. You just learned to use the terminal and Git.
Week 2:  Git branching, REST APIs, curl
Week 3:  Dart language fundamentals
Week 4:  Flutter UI, widgets, navigation
Week 5:  Sprint planning workshop, project proposals
Week 6:  State management with Riverpod
Week 7:  Local data persistence with SQLite
Week 8:  Networking, REST API integration
Week 9:  Authentication and security
Week 10: Testing strategies
Week 11: Advanced Flutter (charts, animations)
Week 12: CI/CD and deployment
Week 13: Polish and refactoring
Week 14: Final presentations

Every week builds on the previous ones. The skills you learned today
(terminal, Git, GitHub) will be used in EVERY subsequent week.
```

> PRESENTER NOTE: Emphasize that week 1 skills compound. "You'll run git commands
> hundreds of times. If it feels awkward now, that's normal. By week 4, it will
> be muscle memory."

---

## 6. Course Overview (5 min)

### Assessment Structure

| Component | Weight | Description |
|---|---|---|
| Weekly assignments | 40% | Hands-on exercises, submitted via GitHub |
| Midterm project | 20% | Checkpoint: working app with basic features |
| Final project | 30% | Complete mood tracker app with all features |
| Participation | 10% | Lab attendance, code reviews, contributions |

### AI Tools Policy

- **Weeks 1--3:** AI tools are **not allowed**. Build genuine understanding first.
- **Weeks 4--14:** AI tools (ChatGPT, Copilot, etc.) are **allowed and encouraged** --- but you must understand what the AI generates. "I don't know, the AI wrote it" is not an acceptable answer during code review.

The goal is not to avoid AI. The goal is to use it effectively, which requires understanding the fundamentals.

### What's Next: Week 2

Next week you will learn:

- **Git branching and merging** --- working on features without breaking `main`
- **REST APIs** --- how apps talk to servers
- **curl** --- making HTTP requests from the terminal

Come to the lab with your SSH keys working and at least one repository on GitHub.

> PRESENTER NOTE: End with: "The hardest part is over. The terminal and Git are the
> most unfamiliar tools in this course. Everything else builds on top of what you
> already know from programming. See you next week."

---

## Key Takeaways

1. **Version control is not optional** --- especially in healthcare software
2. **Git stores snapshots**, not diffs. Each commit is a complete picture of your project.
3. **The three areas** (working directory, staging, repository) give you control over what you commit
4. **SSH keys use asymmetric cryptography** --- public key is a padlock, private key opens it
5. **Professional teams** use branches, pull requests, and code review --- and so will you
6. **These tools are the foundation** for everything we build in the next 13 weeks

---

## Further Reading (Optional)

If you want to go deeper on any topic covered today:

- **Git internals:** [Pro Git Book, Chapter 10](https://git-scm.com/book/en/v2/Git-Internals-Plumbing-and-Porcelain) (free online)
- **SSH explained:** [SSH.com: How Does SSH Work](https://www.ssh.com/academy/ssh/protocol)
- **The Missing Semester of Your CS Education:** [MIT Course](https://missing.csail.mit.edu/) (the inspiration for this lecture's title)
- **Why version control matters in science:** [A Quick Introduction to Version Control with Git and GitHub](https://journals.plos.org/ploscompbiol/article?id=10.1371/journal.pcbi.1004668)
