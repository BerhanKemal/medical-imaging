# Week 1 Lab: Terminal, Git & GitHub

**Course:** Mobile Apps for Healthcare
**Duration:** ~2 hours hands-on
**Prerequisites:** C/C++ and Python experience (no terminal or git knowledge required)

> **Important:** AI tools (ChatGPT, Copilot, etc.) are **not allowed** in Weeks 1--3.
> The goal is to build genuine understanding of these foundational tools.
> You will rely on AI-assisted workflows later in the course --- but first, learn the basics yourself.

---

## Learning Objectives

By the end of this lab, you will be able to:

1. **Navigate** your computer's file system using the terminal (`pwd`, `ls`, `cd`)
2. **Create and manage** files and folders from the command line (`mkdir`, `touch`, `echo`, `cat`, `rm`)
3. **Initialize** a Git repository and understand what it does
4. **Track changes** using the Git workflow: `git add` -> `git commit` -> `git push`
5. **Read** your project's history with `git log` and `git diff`
6. **Set up SSH keys** and connect securely to GitHub
7. **Push** a local repository to GitHub so others can see your work

---

## Before You Start

You will need:

- A computer with macOS, Windows, or Linux
- An internet connection
- About 2 hours of uninterrupted time

**Which terminal should I open?**

| Operating System | What to open |
|---|---|
| **macOS** | Open **Terminal** (press `Cmd + Space`, type "Terminal", hit Enter) |
| **Windows** | Install and open **Git Bash** (download from [git-scm.com](https://git-scm.com/downloads)). Alternatively, use **Windows PowerShell**, but note that some commands differ. This guide uses Git Bash / Unix-style commands. |
| **Linux** | Open your default **Terminal** emulator (usually `Ctrl + Alt + T`) |

Once your terminal is open, you should see a blinking cursor waiting for input. It might look something like this:

```
username@computer ~ %
```

or

```
username@computer:~$
```

This is called the **prompt**. It means the terminal is ready for you to type a command. Do not be intimidated by it --- it is just a different way to talk to your computer.

---

## Part 1: Terminal Basics (~30 min)

### 1.1 Where Am I? --- `pwd`

The first thing to know: your terminal is always "standing" in some folder (directory) on your computer. To find out where you are, type:

```bash
pwd
```

Press **Enter**. You should see something like:

```
/Users/yourname
```

(on macOS/Linux) or:

```
/c/Users/yourname
```

(on Windows with Git Bash).

This is your **home directory** --- think of it as your starting location.

### 1.2 What Is Here? --- `ls`

To see what files and folders exist in your current location:

```bash
ls
```

Expected output (yours will differ):

```
Desktop    Documents  Downloads  Music  Pictures
```

Want more detail? Try:

```bash
ls -la
```

This shows **all** files (including hidden ones that start with `.`) and extra information like file sizes and dates.

> **Windows PowerShell note:** Use `dir` instead of `ls`. In Git Bash, `ls` works normally.

### 1.3 Moving Around --- `cd`

`cd` stands for "change directory." It moves you into a different folder.

```bash
cd Desktop
```

Now check where you are:

```bash
pwd
```

Expected output:

```
/Users/yourname/Desktop
```

To go **back up** one level (to the parent folder):

```bash
cd ..
```

To go directly to your home directory from anywhere:

```bash
cd ~
```

To go to an **absolute path** (a full path starting from the root):

```bash
cd /Users/yourname/Documents
```

> **Tip:** Press **Tab** to autocomplete folder and file names. Start typing a name and press Tab --- the terminal will finish it for you. This saves time and prevents typos.

> **Common mistake:** Typing `cd` with a folder name that does not exist. You will see:
> ```
> bash: cd: NoSuchFolder: No such file or directory
> ```
> This just means you misspelled the name or the folder is not in your current location. Use `ls` to check what folders are available.

### 1.4 Creating Folders --- `mkdir`

Let us create a workspace for this course. Go to your home directory first:

```bash
cd ~
```

Now create a folder:

```bash
mkdir mhealth-course
```

Verify it was created:

```bash
ls
```

You should see `mhealth-course` in the list. Now move into it:

```bash
cd mhealth-course
```

You can create nested folders in one command with the `-p` flag:

```bash
mkdir -p week-01/exercises
```

This creates `week-01` and `exercises` inside it, even if `week-01` did not exist yet.

### 1.5 Creating and Viewing Files --- `cat`, `touch`

Move into the exercises folder:

```bash
cd week-01/exercises
```

Create an empty file:

```bash
touch notes.txt
```

Verify it exists:

```bash
ls
```

```
notes.txt
```

Now let us put some text in it. We will use a simple redirect:

```bash
echo "Hello, this is my first terminal-created file!" > notes.txt
```

View the contents of the file:

```bash
cat notes.txt
```

Expected output:

```
Hello, this is my first terminal-created file!
```

To **append** text to a file (without overwriting), use `>>`:

```bash
echo "This is a second line." >> notes.txt
cat notes.txt
```

Expected output:

```
Hello, this is my first terminal-created file!
This is a second line.
```

> **Common mistake:** Using `>` when you meant `>>`. A single `>` **overwrites** the entire file. Double `>>` **appends**. Be careful!

### 1.6 Deleting Files and Folders --- `rm`

Remove a file:

```bash
rm notes.txt
```

Verify it is gone:

```bash
ls
```

To remove an **empty** folder:

```bash
rmdir foldername
```

To remove a folder **and everything inside it**:

```bash
rm -r foldername
```

> **Warning:** `rm` does NOT move files to the Trash. They are permanently deleted. There is no undo. Always double-check before running `rm -r`.

### 1.7 Finding Programs --- `which`

When you type a command like `python` or `git`, how does the terminal know where that program lives on your computer? It searches through a list of directories called the **PATH**.

To see where a specific command lives:

```bash
which git
```

Expected output (example):

```
/usr/bin/git
```

If the command is not installed, you will see no output (or an error message).

Try these:

```bash
which python3
which ls
```

---

> ### How Does This Actually Work? --- What Happens When You Type a Command
>
> When you type `git` and press Enter, your terminal does NOT magically know what to do.
> Here is what actually happens, step by step:
>
> ```
> You type: git status
>         |
>         v
> ┌─────────────────────────────────┐
> │  Shell reads your command       │
> │  Splits it: program = "git"    │
> │              args = "status"    │
> └──────────────┬──────────────────┘
>                |
>                v
> ┌─────────────────────────────────┐
> │  Shell searches the PATH        │
> │                                 │
> │  PATH = /usr/local/bin          │
> │         /usr/bin        <-- found! /usr/bin/git
> │         /bin                    │
> │         /usr/sbin              │
> │         ...                    │
> └──────────────┬──────────────────┘
>                |
>                v
> ┌─────────────────────────────────┐
> │  Shell runs /usr/bin/git        │
> │  with argument "status"         │
> │                                 │
> │  Git does its work and prints   │
> │  the result to your screen      │
> └─────────────────────────────────┘
> ```
>
> **The PATH** is a list of folders that your shell checks, one by one, when you type a command.
> If none of the folders contain a program with that name, you get **"command not found."**
>
> You do not need to memorize this. Just remember: if a command is "not found," it either is not
> installed, or its location is not in your PATH.

---

### 1.8 Exercise: Build a Project Structure

Now practice on your own. Starting from your home directory, do the following:

1. Navigate to `~/mhealth-course`
2. Create the following folder structure:

```
mhealth-course/
  week-01/
    exercises/     (already exists)
    notes/
  week-02/
    exercises/
    notes/
```

3. Inside `week-01/notes/`, create a file called `terminal-commands.txt` and write at least 5 commands you learned today (one per line)
4. Use `cat` to display its contents
5. Navigate back to `~/mhealth-course` and use `ls -R` to see the full tree

Expected output from `ls -R`:

```
.:
week-01  week-02

./week-01:
exercises  notes

./week-01/exercises:

./week-01/notes:
terminal-commands.txt

./week-02:
exercises  notes

./week-02/exercises:

./week-02/notes:
```

> **Tip:** If you make a mistake, do not panic. You can always remove what you created with `rm` or `rm -r` and start over.

---

> ### Self-Check: Terminal Basics
>
> Before moving on, make sure you can answer these questions:
>
> 1. What command shows your current directory?
> 2. What is the difference between `>` and `>>`?
> 3. How do you create a folder and all its parent folders in one command?
> 4. Why is `rm` dangerous compared to dragging a file to the Trash?
> 5. What does the Tab key do in the terminal?

---

## Part 2: Git Basics (~40 min)

### 2.1 What Is Git?

Git is a **version control system** --- it tracks every change you make to your files and lets you go back to any previous version. Think of it as an "unlimited undo" for your entire project, with the ability to see exactly what changed, when, and why.

### 2.2 Configuring Git (One-Time Setup)

Before using git for the first time, tell it who you are. Run these two commands, replacing the placeholder values with your actual name and email:

```bash
git config --global user.name "Your Full Name"
git config --global user.email "your.email@student.agh.edu.pl"
```

These will be attached to every commit you make. You only need to do this once per computer.

You can verify your settings:

```bash
git config --global user.name
git config --global user.email
```

### 2.3 Creating a Repository --- `git init`

Navigate to your course folder and create a new project:

```bash
cd ~/mhealth-course
mkdir my-first-repo
cd my-first-repo
```

Now initialize a git repository:

```bash
git init
```

Expected output:

```
Initialized empty Git repository in /Users/yourname/mhealth-course/my-first-repo/.git/
```

This creates a hidden `.git` folder that stores all version history. You can verify:

```bash
ls -la
```

You will see a `.git` directory listed. **Never manually edit or delete the `.git` folder** --- it contains your entire project history.

---

> ### How Does This Actually Work? --- What's Inside `.git`?
>
> When you run `git init`, Git creates a hidden `.git` directory. This is where **all** of
> Git's data lives. Your project folder looks the same, but now it has a hidden brain:
>
> ```
> my-first-repo/
> ├── .git/                  <-- Git's brain (hidden)
> │   ├── objects/           <-- All your file contents and commits (stored efficiently)
> │   ├── refs/              <-- Pointers to commits (branches, tags)
> │   ├── HEAD               <-- Points to your current branch
> │   ├── config             <-- Repository-specific settings
> │   └── ...                <-- Other internal files
> └── (your project files)   <-- The files you actually work with
> ```
>
> **Key insight:** Git does not store your files somewhere else. Your files stay exactly where
> they are. The `.git` folder just keeps track of every version of every file you tell it to
> track. When you delete `.git`, you lose all history but keep your current files.

---

### 2.4 Checking the State --- `git status`

This is the command you will use most often. It tells you what has changed since your last commit:

```bash
git status
```

Expected output:

```
On branch main
No commits yet
nothing to commit (create/copy files and use "git add" to track)
```

> **Note:** If you see `master` instead of `main`, that is fine. Both are just names for the default branch. To set `main` as the default for future repositories, run:
> ```bash
> git config --global init.defaultBranch main
> ```

### 2.5 Your First Commit

Let us create a file and commit it. This is a three-step process:

**Step 1: Create a file**

```bash
echo "# My First Repository" > README.md
echo "" >> README.md
echo "This is a practice project for the Mobile Apps for Healthcare course." >> README.md
```

**Step 2: Check what git sees**

```bash
git status
```

Expected output:

```
On branch main
No commits yet
Untracked files:
  (use "git add <file>..." to include in what will be committed)
        README.md

nothing added to commit but untracked files present (use "git add" to track)
```

Git sees the file but is **not tracking** it yet. The file is "untracked."

**Step 3: Stage the file**

```bash
git add README.md
```

Check status again:

```bash
git status
```

Expected output:

```
On branch main
No commits yet
Changes to be committed:
  (use "git rm --cached <file>..." to unstage)
        new file:   README.md
```

The file is now **staged** --- it is in the "waiting area" (called the staging area or index), ready to be committed.

**Step 4: Commit**

```bash
git commit -m "Add initial README with project description"
```

Expected output:

```
[main (root-commit) a1b2c3d] Add initial README with project description
 1 file changed, 3 insertions(+)
 create mode 100644 README.md
```

Congratulations --- you just made your first commit!

---

> ### How Does This Actually Work? --- The Three Areas of Git
>
> Git has three "areas" where your files can live. Understanding these is the single most
> important concept in Git:
>
> ```
> ┌───────────────────┐      ┌───────────────────┐      ┌───────────────────┐
> │  WORKING          │      │  STAGING AREA      │      │  REPOSITORY       │
> │  DIRECTORY        │      │  (Index)           │      │  (.git)           │
> │                   │      │                    │      │                   │
> │  The files you    │      │  A "shopping cart" │      │  Permanent        │
> │  see and edit     │      │  of changes you    │      │  history of       │
> │  in your folder   │      │  want to include   │      │  your project     │
> │                   │      │  in your next      │      │                   │
> │                   │      │  commit            │      │                   │
> └────────┬──────────┘      └─────────┬──────────┘      └───────────────────┘
>          │                           │
>          │       git add             │       git commit
>          │ ────────────────────>     │ ────────────────────>
>          │                           │
> ```
>
> **Analogy: Packing a shipping box**
>
> - **Working Directory** = your room. Stuff is scattered around.
> - **`git add`** = putting items into a shipping box. You choose what goes in.
> - **Staging Area** = the packed box, not yet sealed. You can still add or remove items.
> - **`git commit`** = sealing the box, labeling it, and putting it on the shelf. Done.
> - **Repository** = the shelf of sealed, labeled boxes. Permanent record.
>
> **Why does the staging area exist?**
> It lets you choose exactly what goes into each commit. Maybe you changed 5 files, but
> only 2 of them are related to the same task. You stage just those 2 and commit them
> together. The other 3 changes wait for a separate commit.

---

> **What makes a good commit message?**
>
> - Start with a verb: "Add", "Fix", "Update", "Remove", "Refactor"
> - Be specific: "Add README with project description" is better than "first commit"
> - Keep it short (under 72 characters)
> - Describe **what** you did and **why**, not **how**
>
> **Good examples:**
> - `Add patient data model with name and age fields`
> - `Fix temperature conversion from Fahrenheit to Celsius`
> - `Update README with installation instructions`
>
> **Bad examples:**
> - `asdfasdf`
> - `changes`
> - `fixed stuff`
> - `commit 3`

### 2.6 Viewing History --- `git log`

```bash
git log
```

Expected output:

```
commit a1b2c3d4e5f6... (HEAD -> main)
Author: Your Full Name <your.email@student.agh.edu.pl>
Date:   Mon Feb 23 10:30:00 2026 +0100

    Add initial README with project description
```

For a compact view:

```bash
git log --oneline
```

```
a1b2c3d Add initial README with project description
```

### 2.7 Seeing What Changed --- `git diff`

Let us modify our file:

```bash
echo "## Topics" >> README.md
echo "- ECG signal processing" >> README.md
```

Now see what changed:

```bash
git diff
```

Expected output:

```diff
diff --git a/README.md b/README.md
index abc1234..def5678 100644
--- a/README.md
+++ b/README.md
@@ -1,3 +1,5 @@
 # My First Repository

 This is a practice project for the Mobile Apps for Healthcare course.
+## Topics
+- ECG signal processing
```

Lines starting with `+` are additions. Lines starting with `-` are deletions. This is incredibly useful for reviewing your own changes before committing.

> **Key concept:** Always run `git diff` before `git add`, and `git status` before `git commit`. This habit will save you from committing things you did not intend to.

### 2.8 Exercise: Build a Commit History

Now work through this guided exercise to practice the full workflow. You will make **5 commits** to a small project about biomedical engineering topics.

**Commit 1** (already done above): You already committed the README. Now stage and commit the changes you just made:

```bash
git add README.md
git commit -m "Add Topics section with ECG signal processing"
```

**Commit 2**: Create a new file about a biomedical topic:

```bash
echo "# ECG Signal Processing" > ecg-notes.txt
echo "" >> ecg-notes.txt
echo "ECG (electrocardiogram) measures the electrical activity of the heart." >> ecg-notes.txt
echo "It is one of the most common diagnostic tools in cardiology." >> ecg-notes.txt
git add ecg-notes.txt
git commit -m "Add ECG signal processing notes"
```

**Commit 3**: Add more content to the ECG file:

```bash
echo "" >> ecg-notes.txt
echo "## Key Components" >> ecg-notes.txt
echo "- P wave: atrial depolarization" >> ecg-notes.txt
echo "- QRS complex: ventricular depolarization" >> ecg-notes.txt
echo "- T wave: ventricular repolarization" >> ecg-notes.txt
git add ecg-notes.txt
git commit -m "Add key ECG wave components to notes"
```

**Commit 4**: Create another topic file:

```bash
echo "# Medical Imaging" > imaging-notes.txt
echo "" >> imaging-notes.txt
echo "Medical imaging allows non-invasive visualization of the body interior." >> imaging-notes.txt
echo "Common modalities: X-ray, CT, MRI, Ultrasound, PET." >> imaging-notes.txt
git add imaging-notes.txt
git commit -m "Add medical imaging overview notes"
```

**Commit 5**: Update the README to reflect all files:

```bash
echo "- Medical imaging" >> README.md
echo "" >> README.md
echo "## Files" >> README.md
echo "- ecg-notes.txt: Notes on ECG signal processing" >> README.md
echo "- imaging-notes.txt: Notes on medical imaging modalities" >> README.md
git add README.md
git commit -m "Update README with medical imaging topic and file listing"
```

Now view your history:

```bash
git log --oneline
```

Expected output:

```
f6e5d4c Update README with medical imaging topic and file listing
d3c2b1a Add medical imaging overview notes
b1a2c3d Add key ECG wave components to notes
e4d5f6a Add ECG signal processing notes
a1b2c3d Add initial README with project description
```

You should see at least 5 commits (possibly 6, since we had the initial README plus the Topics addition). Well done!

> **Common mistakes with git:**
>
> - **Forgetting `git add` before `git commit`:** If you skip `git add`, your changes will not be included in the commit. Always run `git status` before committing to make sure files are staged.
> - **Committing too many things at once:** Each commit should represent one logical change. Do not dump all your work into a single commit at the end.
> - **Vague commit messages:** Future you will thank present you for writing clear messages.

---

> ### Self-Check: Git Basics
>
> Before moving on, make sure you can answer these questions:
>
> 1. What are the three areas of Git? What moves files between them?
> 2. What is the difference between `git add` and `git commit`?
> 3. How do you see what changes you have made since the last commit?
> 4. Why should each commit represent one logical change rather than "everything I did today"?
> 5. What makes a good commit message?

---

## Part 3: GitHub & SSH Setup (~30 min)

### 3.1 Create a GitHub Account

If you do not already have one:

1. Go to [github.com](https://github.com)
2. Click **Sign up**
3. Use your student email (`@student.agh.edu.pl`) --- this will let you access the free GitHub Student Developer Pack later
4. Choose a professional username (you may use this on your CV someday)

### 3.2 Generate an SSH Key

SSH keys allow you to securely connect to GitHub without typing your password every time.

**Step 1:** Open your terminal and run (replace the email with your own):

```bash
ssh-keygen -t ed25519 -C "your.email@student.agh.edu.pl"
```

**Step 2:** When prompted, press **Enter** to accept the default file location:

```
Generating public/private ed25519 key pair.
Enter file in which to save the key (/Users/yourname/.ssh/id_ed25519):
```

Just press **Enter**.

**Step 3:** When prompted for a passphrase, you can either:
- Press **Enter** twice for no passphrase (simpler, but less secure)
- Type a passphrase (more secure --- you will need to type it occasionally)

For this course, no passphrase is fine.

Expected output:

```
Your identification has been saved in /Users/yourname/.ssh/id_ed25519
Your public key has been saved in /Users/yourname/.ssh/id_ed25519.pub
The key fingerprint is:
SHA256:xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx your.email@student.agh.edu.pl
The key's randomart image is:
+--[ED25519 256]--+
|       ...       |
|      o .        |
|     . + .       |
|      . o  .     |
+----[SHA256]-----+
```

**Step 4:** Copy your **public** key to clipboard.

On macOS:
```bash
cat ~/.ssh/id_ed25519.pub | pbcopy
```

On Linux:
```bash
cat ~/.ssh/id_ed25519.pub | xclip -selection clipboard
```

On Windows (Git Bash):
```bash
cat ~/.ssh/id_ed25519.pub | clip
```

If none of those work, just display it and copy manually:
```bash
cat ~/.ssh/id_ed25519.pub
```

It will look something like:

```
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx your.email@student.agh.edu.pl
```

> **Important:** You have TWO key files:
> - `id_ed25519` --- this is your **private** key. NEVER share this with anyone.
> - `id_ed25519.pub` --- this is your **public** key. This is what you give to GitHub.

---

> ### How Does This Actually Work? --- SSH Keys Explained
>
> SSH keys use **asymmetric cryptography** --- a system with TWO keys instead of one:
>
> ```
> ┌─────────────────────────────────────────────────────────────┐
> │                                                             │
> │   PRIVATE KEY (id_ed25519)       PUBLIC KEY (id_ed25519.pub)│
> │   ─────────────────────────      ──────────────────────────│
> │                                                             │
> │   Keep this SECRET.              Share this freely.         │
> │   Like a key to a lock.         Like a padlock you give    │
> │   Only you have it.             to others.                 │
> │                                                             │
> └─────────────────────────────────────────────────────────────┘
> ```
>
> **Analogy: The Padlock and Key**
>
> Imagine you buy 100 identical padlocks, all opened by the same key.
>
> - You **keep the key** (private key) in your pocket. Never let anyone touch it.
> - You **give a padlock** (public key) to GitHub, to your university server, to anyone.
> - When GitHub wants to verify it is really you, it uses the padlock to create a challenge.
>   Only your key can solve it. If the answer is correct, GitHub knows it is you.
>
> **This is why you NEVER share your private key.** Anyone with your private key can
> impersonate you --- it is like giving away the master key to your identity.
>
> ```
> Your Computer                          GitHub Server
> ┌──────────────┐                      ┌──────────────┐
> │              │  "I'm user X"        │              │
> │              │ ──────────────────>   │  Has your    │
> │              │                      │  public key  │
> │  Has your    │  "Prove it. Sign     │  (padlock)   │
> │  private key │   this challenge"    │              │
> │  (key)       │ <──────────────────  │              │
> │              │                      │              │
> │  Signs with  │  Sends signature     │  Verifies    │
> │  private key │ ──────────────────>  │  with public │
> │              │                      │  key         │
> │              │  "OK, you're in"     │              │
> │              │ <──────────────────  │              │
> └──────────────┘                      └──────────────┘
> ```

---

### 3.3 Add the SSH Key to GitHub

1. Go to [github.com](https://github.com) and log in
2. Click your **profile picture** (top right) and choose **Settings**
3. In the left sidebar, click **SSH and GPG keys**
4. Click the green **New SSH key** button
5. Fill in:
   - **Title:** Something descriptive, like "My Laptop" or "AGH Lab Computer"
   - **Key type:** Leave as "Authentication Key"
   - **Key:** Paste your public key (the one you just copied)
6. Click **Add SSH key**

### 3.4 Test the Connection

```bash
ssh -T git@github.com
```

You might see this warning the first time:

```
The authenticity of host 'github.com (...)' can't be established.
ED25519 key fingerprint is SHA256:+DiY3wvvV6TuJJhbpZisF/zLDA0zPMSvHdkr4UvCOqU.
Are you sure you want to continue connecting (yes/no/[fingerprint])?
```

Type `yes` and press **Enter**.

Expected success output:

```
Hi yourusername! You've successfully authenticated, but GitHub does not provide shell access.
```

If you see this message, your SSH setup is complete!

> **Troubleshooting:**
>
> - **"Permission denied (publickey)"**: Your SSH key is not set up correctly. Check that you copied the `.pub` file (not the private key) and that it was added to GitHub. You can also try running `ssh-add ~/.ssh/id_ed25519` to add the key to your SSH agent.
> - **"Connection timed out"**: You might be on a network that blocks SSH. Try the HTTPS method instead (ask the instructor for help).

---

> ### Self-Check: SSH Setup
>
> Before moving on, make sure you can answer these questions:
>
> 1. What is the difference between your public key and your private key?
> 2. Which key file do you give to GitHub?
> 3. Why should you NEVER share your private key?
> 4. What command tests your SSH connection to GitHub?

---

## Part 4: Push to GitHub & Clone (~15 min)

### 4.1 Push Your Repository to GitHub

**Step 1:** Create a new repository on GitHub:

1. Go to [github.com](https://github.com) and click the **+** icon (top right) then **New repository**
2. Name it `my-first-repo`
3. Leave it **Public**
4. Do **NOT** check "Add a README file" (you already have one locally)
5. Click **Create repository**

GitHub will show you instructions. We will use the "push an existing repository" option.

**Step 2:** In your terminal, make sure you are inside `my-first-repo`:

```bash
cd ~/mhealth-course/my-first-repo
```

**Step 3:** Connect your local repository to GitHub:

```bash
git remote add origin git@github.com:YOUR-USERNAME/my-first-repo.git
```

Replace `YOUR-USERNAME` with your actual GitHub username.

**Step 4:** Push your code:

```bash
git push -u origin main
```

> **Note:** If your default branch is called `master` instead of `main`, use:
> ```bash
> git push -u origin master
> ```

Expected output:

```
Enumerating objects: 15, done.
Counting objects: 100% (15/15), done.
Delta compression using up to 8 threads
Compressing objects: 100% (10/10), done.
Writing objects: 100% (15/15), 1.23 KiB | 1.23 MiB/s, done.
Total 15 (delta 2), reused 0 (delta 0)
remote: Resolving deltas: 100% (2/2), done.
To github.com:YOUR-USERNAME/my-first-repo.git
 * [new branch]      main -> main
branch 'main' set up to track 'origin/main'.
```

Now go to `https://github.com/YOUR-USERNAME/my-first-repo` in your browser --- you should see all your files and commit history there!

> **What does `-u` mean?** The `-u` flag tells git to remember that `origin main` is the default place to push to. After using `-u` once, you can simply type `git push` in the future without specifying the remote and branch.

> **Troubleshooting:**
>
> - **"error: remote origin already exists"**: You already added a remote. To fix it:
>   ```bash
>   git remote remove origin
>   git remote add origin git@github.com:YOUR-USERNAME/my-first-repo.git
>   ```
> - **"error: src refspec main does not match any"**: You have not made any commits yet, or your branch is named differently. Run `git branch` to see your branch name.

---

> ### How Does This Actually Work? --- Local vs Remote
>
> Until you pushed, your repository existed only on your computer. Now there are TWO copies:
>
> ```
> ┌─────────────────────────┐          ┌─────────────────────────┐
> │   YOUR COMPUTER         │          │   GITHUB (Remote)       │
> │                         │          │                         │
> │   my-first-repo/        │          │   my-first-repo/        │
> │   ├── .git/             │   push   │   ├── README.md         │
> │   ├── README.md         │ ──────>  │   ├── ecg-notes.txt     │
> │   ├── ecg-notes.txt     │          │   ├── imaging-notes.txt │
> │   └── imaging-notes.txt │  clone   │   └── (commit history)  │
> │                         │ <──────  │                         │
> │   (full history)        │          │   (full history)        │
> └─────────────────────────┘          └─────────────────────────┘
> ```
>
> - **`git push`** sends your commits from your computer to GitHub (local -> remote)
> - **`git clone`** downloads a repository from GitHub to your computer (remote -> local)
> - **`git pull`** downloads new commits from GitHub that you don't have yet (we'll cover this later)
>
> Both copies are full repositories with complete history. Git is **distributed** --- there
> is no single "master" copy. Your local repo and the GitHub repo are equal partners.

---

### 4.2 What Is Cloning?

Cloning means downloading a copy of a repository from GitHub to your computer. It copies all files **and** the entire commit history.

### 4.3 Clone a Repository

Navigate to your course folder:

```bash
cd ~/mhealth-course
```

Clone the course exercise repository:

```bash
git clone git@github.com:agh-mhealth/week-01-exercises.git
```

Expected output:

```
Cloning into 'week-01-exercises'...
remote: Enumerating objects: 10, done.
remote: Counting objects: 100% (10/10), done.
remote: Compressing objects: 100% (7/7), done.
remote: Total 10 (delta 1), reused 10 (delta 1), pack-reused 0
Receiving objects: 100% (10/10), done.
Resolving deltas: 100% (1/1), done.
```

Move into the cloned folder:

```bash
cd week-01-exercises
```

Look around:

```bash
ls
git log --oneline
```

### 4.4 Make Changes and Push

**Step 1:** Create a file with your name (replace with your actual name):

```bash
echo "Jan Kowalski - Biomedical Engineering, Year 3" > students/jan-kowalski.txt
```

> **Note:** If the `students/` directory does not exist, create it first with `mkdir students`.

**Step 2:** Stage and commit:

```bash
git add students/jan-kowalski.txt
git commit -m "Add Jan Kowalski to students list"
```

**Step 3:** Push to GitHub:

```bash
git push
```

That is it! Since the repository was cloned, git already knows where to push.

### 4.5 The Full Cycle

Here is the workflow you just learned, summarized:

```
[Edit files] --> git add --> git commit -m "message" --> git push
```

You will repeat this cycle hundreds of times throughout this course. It will become second nature.

---

> ### Self-Check: GitHub & Pushing
>
> Before moving on, make sure you can answer these questions:
>
> 1. What is the difference between a local repository and a remote repository?
> 2. What does `git push` do?
> 3. What does `git clone` do?
> 4. After cloning a repository, do you need to run `git init`? Why or why not?
> 5. What is the complete workflow from editing a file to getting it on GitHub?

---

## Individual Assignment

### Task: Create Your Biomedical Engineering Knowledge Repository

Create a personal GitHub repository that serves as a collection of notes about biomedical engineering topics that interest you.

### Requirements

1. **Create a new GitHub repository** named `bme-knowledge-base` (or a similar descriptive name)
2. **Work locally** --- create the project on your computer, use `git init`, and push to GitHub
3. **Make at least 5 meaningful commits**, each representing a distinct change. For example:
   - Commit 1: Add initial README describing the repository's purpose
   - Commit 2: Add notes on a first topic (e.g., ECG signal processing)
   - Commit 3: Add notes on a second topic (e.g., medical imaging)
   - Commit 4: Expand one of the existing topics with more detail
   - Commit 5: Update the README with a table of contents or list of all topics
4. **Each commit message must be meaningful** --- no "asdf" or "update" messages
5. **The repository must contain at least 3 files** (including the README)
6. **Push everything to GitHub** so the full commit history is visible

### Topic Ideas (Choose What Interests You)

- ECG / EEG signal processing
- Medical imaging (MRI, CT, ultrasound)
- Biomechanics and motion analysis
- Prosthetics and orthotics
- Telemedicine and remote monitoring
- Wearable health sensors
- Drug delivery systems
- Biomedical data standards (HL7, FHIR, DICOM)
- Rehabilitation engineering
- Neural interfaces and brain-computer interfaces

### Submission

Submit the URL of your GitHub repository (e.g., `https://github.com/your-username/bme-knowledge-base`) through the course submission system.

### Grading Criteria

| Criterion | Points |
|---|---|
| Repository exists on GitHub and is accessible | 1 |
| At least 5 meaningful commits with good messages | 2 |
| At least 3 files with actual content | 1 |
| README clearly describes the project | 1 |
| **Total** | **5** |

### Deadline

Submit before the start of the Week 2 lab session.

---

## Cheat Sheet

Keep this reference handy. You will use these commands every week.

### Terminal Commands

| Command | What It Does | Example |
|---|---|---|
| `pwd` | Print current directory | `pwd` |
| `ls` | List files and folders | `ls -la` |
| `cd <path>` | Change directory | `cd ~/Documents` |
| `cd ..` | Go up one directory | `cd ..` |
| `cd ~` | Go to home directory | `cd ~` |
| `mkdir <name>` | Create a new folder | `mkdir my-project` |
| `mkdir -p <path>` | Create nested folders | `mkdir -p a/b/c` |
| `touch <file>` | Create an empty file | `touch notes.txt` |
| `cat <file>` | Display file contents | `cat notes.txt` |
| `echo "text" > file` | Write text to file (overwrites) | `echo "hello" > file.txt` |
| `echo "text" >> file` | Append text to file | `echo "world" >> file.txt` |
| `rm <file>` | Delete a file (permanent!) | `rm old-file.txt` |
| `rm -r <folder>` | Delete a folder and contents (permanent!) | `rm -r old-folder` |
| `which <command>` | Show where a command is installed | `which git` |

### Git Commands

| Command | What It Does | Example |
|---|---|---|
| `git init` | Create a new repository | `git init` |
| `git status` | Show what has changed | `git status` |
| `git add <file>` | Stage a file for commit | `git add README.md` |
| `git add .` | Stage all changed files | `git add .` |
| `git commit -m "msg"` | Save staged changes with a message | `git commit -m "Add README"` |
| `git log` | Show commit history | `git log --oneline` |
| `git diff` | Show unstaged changes | `git diff` |
| `git remote add origin <url>` | Connect to a GitHub repository | `git remote add origin git@github.com:user/repo.git` |
| `git push -u origin main` | Push to GitHub (first time) | `git push -u origin main` |
| `git push` | Push to GitHub (after first time) | `git push` |
| `git clone <url>` | Download a repository from GitHub | `git clone git@github.com:user/repo.git` |

### SSH Setup (One-Time)

```bash
# Generate SSH key
ssh-keygen -t ed25519 -C "your.email@student.agh.edu.pl"

# Display public key (copy this to GitHub)
cat ~/.ssh/id_ed25519.pub

# Test connection
ssh -T git@github.com
```

### Git Configuration (One-Time)

```bash
git config --global user.name "Your Full Name"
git config --global user.email "your.email@student.agh.edu.pl"
git config --global init.defaultBranch main
```

### The Full Git Workflow

```
┌──────────────┐     ┌──────────────┐     ┌──────────────┐     ┌──────────────┐
│  Edit your   │     │  Stage your  │     │  Commit with │     │  Push to     │
│  files       │────>│  changes     │────>│  a message   │────>│  GitHub      │
│              │     │              │     │              │     │              │
│  (just work  │     │  git add     │     │  git commit  │     │  git push    │
│   normally)  │     │  <files>     │     │  -m "msg"    │     │              │
└──────────────┘     └──────────────┘     └──────────────┘     └──────────────┘
```

---

## Troubleshooting FAQ

**Q: I get "command not found" when I type `git`.**
A: Git is not installed. Download it from [git-scm.com](https://git-scm.com/downloads) and install it. Close and reopen your terminal after installing.

**Q: I accidentally initialized git in the wrong folder.**
A: Just delete the hidden `.git` folder: `rm -r .git`. This removes the git repository but keeps your files.

**Q: I committed something I did not want to commit.**
A: Do not panic. Git keeps history of everything. Ask the instructor for help --- we will cover how to undo things in a later session.

**Q: `git push` asks for a username and password.**
A: You are using HTTPS instead of SSH. Either:
- Set up SSH (see Part 3 above), or
- When it asks for a password, use a **Personal Access Token**, not your GitHub password (GitHub no longer accepts passwords for HTTPS). You can create a token at GitHub > Settings > Developer settings > Personal access tokens.

**Q: I see "fatal: not a git repository" when I run git commands.**
A: You are in a folder that is not a git repository. Either `cd` into the correct folder, or run `git init` to make the current folder a repository.

**Q: My terminal looks different from the examples.**
A: That is normal. Different systems and configurations make terminals look different. The commands and their outputs are what matter, not the appearance of the prompt.

**Q: I see "error: failed to push some refs" when pushing.**
A: This usually means the remote has changes you do not have locally. For now, make sure you are pushing to an empty remote repository. We will cover resolving this in a later session.

**Q: I see "Permission denied (publickey)" when pushing or testing SSH.**
A: Your SSH key is not configured correctly. Try these steps:
1. Verify your key exists: `ls ~/.ssh/id_ed25519.pub`
2. Verify it is added to GitHub: go to GitHub > Settings > SSH and GPG keys
3. Try adding the key to your SSH agent: `ssh-add ~/.ssh/id_ed25519`
4. Test again: `ssh -T git@github.com`

**Q: `ssh-keygen` says "command not found" on Windows.**
A: Make sure you are using **Git Bash**, not Windows Command Prompt or PowerShell. Git Bash includes SSH tools. If you installed Git for Windows, Git Bash should be available.

**Q: I see `master` everywhere but the guide says `main`.**
A: Both are just names for the default branch. You can use either one. To change your default for new repositories, run `git config --global init.defaultBranch main`.

---

> **You made it!** You now know the basic tools that every software developer uses daily. These skills will be the foundation for everything we build in this course. See you in Week 2!
