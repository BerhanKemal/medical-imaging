# Week 2 Lab: Git Branching, REST APIs & curl

> **Course:** Mobile Apps for Healthcare
> **Duration:** ~2 hours
> **Prerequisites:** Week 1 (terminal basics, `git init/add/commit/push`, GitHub account with SSH)

!!! warning "No AI tools in Weeks 1–3"
    AI tools (ChatGPT, Copilot, etc.) are **not allowed** in Weeks 1–3. Type every command yourself. If you get stuck, ask your instructor or a classmate.

!!! tip "Pacing"
    This lab covers a lot of ground. If you don't finish Part 4 (FastAPI) during the session, it can be completed as homework. Focus on mastering Parts 1-3 (git branching, REST concepts, curl) during the lab.

---

## Learning Objectives

By the end of this lab you will be able to:

1. Create, switch, and merge Git branches.
2. Resolve a merge conflict by hand.
3. Open and merge a Pull Request on GitHub.
4. Set up a Python virtual environment and install packages.
5. Build a minimal REST API with FastAPI.
6. Test API endpoints with `curl`.

!!! example "Healthcare context"
    REST APIs are the backbone of modern health systems. When your phone syncs fitness data to the cloud, when a hospital system queries a patient's lab results, or when a telemedicine app connects to a video service — they all use HTTP APIs following the patterns you'll learn today. The HL7 FHIR standard (Fast Healthcare Interoperability Resources) is built entirely on RESTful API principles.

---

## Part 1: Git Branching & Merging (~35 min)

### 1.1 Why branches?

Branches let you work on a feature or experiment without touching the main codebase. When the work is ready, you merge it back. This is a core workflow in every professional team.

```
main:       A --- B --- C
                   \
feature:            D --- E
```

### 1.2 Creating and switching branches

Open your terminal and navigate to any local Git repository (you can use the one from Week 1).

```bash
# See which branch you are on
git branch

# Create a new branch called "feature-greeting"
git branch feature-greeting

# List branches again — the new one appears, but you are still on main
git branch

# Switch to the new branch (pick ONE of the methods below)
git checkout feature-greeting
# OR (newer syntax, recommended)
git switch feature-greeting
```

You can also create **and** switch in one step:

```bash
git checkout -b feature-greeting
# OR
git switch -c feature-greeting
```

### 1.3 Making changes on a branch

While on `feature-greeting`, create a file:

```bash
echo "Hello from feature branch!" > greeting.txt
git add greeting.txt
git commit -m "Add greeting.txt on feature branch"
```

Switch back to `main` and notice that `greeting.txt` does not exist there:

```bash
git switch main
ls greeting.txt    # file not found — it only exists on the feature branch
```

### 1.4 Merging a branch

To bring the feature branch changes into `main`:

```bash
# Make sure you are on the branch you want to merge INTO
git switch main

# Merge the feature branch
git merge feature-greeting
```

Now `greeting.txt` exists on `main` as well. You can delete the branch if you no longer need it:

```bash
git branch -d feature-greeting
```

### 1.5 Merge Conflict Exercise

A **merge conflict** happens when two branches change the **same lines** in the **same file** and Git cannot decide which version to keep. You must resolve it manually.

#### Setup

You will create a merge conflict yourself by simulating two branches that edit the same file differently.

```bash
# Create a new practice repo
mkdir conflict-exercise && cd conflict-exercise
git init

# Create a patient file on main
cat > patient_info.txt << 'EOF'
Patient: Jane Doe
Age: 45
Blood pressure: 118/76 mmHg
Heart rate: 72 bpm
Notes: Regular checkup
EOF

git add patient_info.txt
git commit -m "Add patient info file"
```

Now create two branches that change the **same line** differently:

```bash
# Branch A: doctor updates blood pressure
git switch -c branch-a
```

Open `patient_info.txt` in your text editor and change the blood pressure line to:

```
Blood pressure: 120/80 mmHg
```

Save the file, then commit:

```bash
git add patient_info.txt
git commit -m "Update BP reading (branch-a)"
```

Now go back to main, create branch B, and make a **different** change to the same line:

```bash
git switch main
git switch -c branch-b
```

Open `patient_info.txt` again and change the blood pressure line to:

```
Blood pressure: 130/85 mmHg
```

Save the file, then commit:

```bash
git add patient_info.txt
git commit -m "Update BP reading (branch-b)"
```

!!! tip "Automation shortcut (optional)"
    If you prefer the command line, you can use `sed` instead of a text editor:
    ```bash
    sed -i.bak 's/Blood pressure: 118\/76 mmHg/Blood pressure: 120\/80 mmHg/' patient_info.txt && rm -f patient_info.txt.bak
    ```
    But learning to edit files manually is more important at this stage — you'll need that skill for resolving real conflicts.

#### Steps

1. **Explore branch-a:**

```bash
git switch branch-a
cat patient_info.txt
# Shows: Blood pressure: 120/80 mmHg
```

2. **Explore branch-b:**

```bash
git switch branch-b
cat patient_info.txt
# Shows: Blood pressure: 130/85 mmHg
```

3. **Merge branch-a into branch-b** (you are currently on `branch-b`):

```bash
git merge branch-a
```

Git will print something like:

```
Auto-merging patient_info.txt
CONFLICT (content): Merge conflict in patient_info.txt
Automatic merge failed; fix conflicts and then commit the result.
```

4. **Open the conflicted file** in your editor. You will see conflict markers:

```
<<<<<<< HEAD
Blood pressure: 130/85 mmHg
=======
Blood pressure: 120/80 mmHg
>>>>>>> branch-a
```

What do these markers mean?

| Marker | Meaning |
|--------|---------|
| `<<<<<<< HEAD` | Start of YOUR current branch's version (branch-b) |
| `=======` | Separator between the two versions |
| `>>>>>>> branch-a` | End of the INCOMING branch's version (branch-a) |

5. **Resolve the conflict** by editing the file. Remove all three marker lines and keep the content you want. For example, you might decide the correct value is:

```
Blood pressure: 125/82 mmHg
```

6. **Stage and commit the resolution:**

```bash
git add patient_info.txt
git commit -m "Resolve merge conflict in patient_info.txt"
```

7. Verify with `git log --oneline --graph` to see the merge commit.

#### Key takeaways

- Conflicts are normal. They are not errors.
- Always read both versions carefully before deciding what to keep.
- Never leave conflict markers (`<<<<<<<`, `=======`, `>>>>>>>`) in committed files.

### Self-Check: Part 1

Before continuing, make sure you can answer these questions:

- [ ] You can create a new branch and switch to it.
- [ ] You understand that changes on a branch are isolated from `main` until merged.
- [ ] You have resolved a merge conflict by editing a file and removing the conflict markers.
- [ ] You can explain what `<<<<<<<`, `=======`, and `>>>>>>>` mean in a conflict file.

---

## Part 2: Pull Requests on GitHub (~20 min)

A **Pull Request** (PR) is a request to merge your branch into another branch on a remote repository. It is the standard way teams review and discuss code before merging.

### 2.1 Push a branch to GitHub

Start from your local repository (the one from Part 1 or a fresh one):

```bash
# Create and switch to a new branch
git switch -c feature-health-tip

# Make a change
echo "Drink at least 2 liters of water daily." > health_tip.txt
git add health_tip.txt
git commit -m "Add daily health tip"

# Push the branch to GitHub
# The -u flag sets up tracking so future pushes are simpler
git push -u origin feature-health-tip
```

### 2.2 Create a Pull Request on GitHub

1. Open your repository on **github.com** in a browser.
2. GitHub will usually show a yellow banner saying _"feature-health-tip had recent pushes"_ with a green **"Compare & pull request"** button. Click it.
   - If you do not see the banner, click the **"Branch"** dropdown, select `feature-health-tip`, then click **"Contribute" > "Open pull request"**.
3. On the **"Open a pull request"** page:
   - **Base branch:** `main` (the branch you want to merge into).
   - **Compare branch:** `feature-health-tip` (your feature branch).
   - **Title:** Write a short, descriptive title, e.g., _"Add daily health tip file"_.
   - **Description:** Explain what the PR does and why. Example: _"Adds a health_tip.txt file with a hydration reminder."_
4. Click the green **"Create pull request"** button.

### 2.3 Review a Pull Request

Pull Requests allow teammates to review your code before it is merged.

1. On the PR page, click the **"Files changed"** tab to see the diff.
2. You can click the **"+"** icon next to any line to leave a comment.
3. After reviewing, click **"Review changes"** in the top-right corner of the "Files changed" tab. You have three options:
   - **Comment** — general feedback, does not approve or block.
   - **Approve** — you are satisfied with the changes.
   - **Request changes** — something needs to be fixed before merging.
4. Click **"Submit review"**.

> **Exercise:** Pair up with a classmate. Push a branch to your own repo, create a PR, and then review each other's PR. Leave at least one line comment and approve.

### 2.4 Merge a Pull Request on GitHub

1. Go back to the **"Conversation"** tab of the PR.
2. If all checks pass and the PR is approved, click the green **"Merge pull request"** button.
3. Click **"Confirm merge"**.
4. Optionally, click **"Delete branch"** to clean up the remote feature branch.

### 2.5 Update your local repository

After merging on GitHub, your local `main` is behind. Update it:

```bash
git switch main
git pull origin main
```

Now your local `main` contains the merged changes.

### Self-Check: Part 2

- [ ] You have pushed a branch to GitHub and opened a Pull Request.
- [ ] You have reviewed a classmate's PR (or at least know how to: Files changed tab → line comments → Submit review).
- [ ] You have merged a PR and pulled the updated `main` locally.
- [ ] You can explain the difference between merging locally (`git merge`) and merging on GitHub (via a PR).

---

## Part 3: Python Virtual Environment & FastAPI (~40 min)

### 3.1 What is a virtual environment?

A **virtual environment** is an isolated Python installation. Packages you install inside it do not affect your system Python or other projects. This prevents version conflicts between projects.

### 3.2 Create and activate a virtual environment

```bash
# Navigate to a new project folder
mkdir mood-api && cd mood-api
```

Create a virtual environment:

=== "macOS / Linux"

    ```bash
    python3 -m venv venv
    ```

=== "Windows (Git Bash)"

    ```bash
    python -m venv venv
    ```

Activate it:

=== "macOS / Linux"

    ```bash
    source venv/bin/activate
    ```

=== "Windows (Git Bash)"

    ```bash
    source venv/Scripts/activate
    ```

When activated, you will see `(venv)` at the beginning of your terminal prompt. To deactivate later, simply type `deactivate`.

### 3.3 Install FastAPI and Uvicorn

```bash
pip install fastapi uvicorn
```

- **FastAPI** is a modern Python web framework for building APIs.
- **Uvicorn** is an ASGI server that runs your FastAPI application.

You can verify the installation:

```bash
pip list
```

### 3.4 Build the Mood Tracking API (step by step)

We will build a simple API that tracks mood entries. Create a file called `main.py`. You can start from the starter template provided in `fastapi-starter/main.py`, or build from scratch by following the steps below.

#### Step 1: Imports and app setup

Create `main.py` and add:

```python
from fastapi import FastAPI

app = FastAPI(title="Mood API", description="A simple mood tracking API")
```

#### Step 2: In-memory storage

We will store mood entries in a plain Python list (no database needed for now):

```python
mood_entries = []
```

#### Step 3: Define a data model

FastAPI uses **Pydantic** models to validate incoming data. Add this import at the top and then define the model:

```python
from pydantic import BaseModel

class MoodEntry(BaseModel):
    score: int
    note: str
```

#### Step 4: `GET /health` endpoint

This is a simple endpoint to check if the API is running:

```python
@app.get("/health")
def health_check():
    """Check if the API is running."""
    return {"status": "healthy"}
```

#### Step 5: `POST /mood` endpoint

This endpoint accepts a mood entry and stores it:

```python
@app.post("/mood")
def create_mood(entry: MoodEntry):
    """Record a new mood entry."""
    mood_entries.append(entry)
    return entry
```

FastAPI will automatically:
- Parse the JSON request body.
- Validate that `score` is an integer and `note` is a string.
- Return a `422 Unprocessable Entity` error if the data is invalid.

#### Step 6: `GET /moods` endpoint

This endpoint returns all stored mood entries:

```python
@app.get("/moods")
def get_moods():
    """Retrieve all mood entries."""
    return mood_entries
```

#### Step 7: Run the application

```bash
uvicorn main:app --reload
```

- `main` refers to the file `main.py`.
- `app` refers to the `app = FastAPI(...)` object inside it.
- `--reload` automatically restarts the server when you edit `main.py`.

You should see output like:

```
INFO:     Uvicorn running on http://127.0.0.1:8000 (Press CTRL+C to quit)
INFO:     Started reloader process
```

### 3.5 Explore Swagger UI

Open your browser and go to:

```
http://localhost:8000/docs
```

FastAPI automatically generates an **interactive API documentation** page (Swagger UI). You can:

- See all your endpoints.
- Click **"Try it out"** to send requests directly from the browser.
- See request/response schemas.

There is also an alternative documentation page at `http://localhost:8000/redoc`.

### Self-Check: Part 3

- [ ] You created and activated a Python virtual environment (you see `(venv)` in your prompt).
- [ ] Your FastAPI server is running — `http://localhost:8000/docs` shows the Swagger UI in your browser.
- [ ] You can explain what `@app.get("/health")` does.
- [ ] You understand that Pydantic validates request data and returns `422` for invalid input.

---

## Part 4: Testing with curl (~15 min)

### 4.1 What is curl?

`curl` (short for "Client URL") is a command-line tool for making HTTP requests. It is installed by default on macOS, Linux, and modern Windows. It lets you test APIs without a browser or GUI tool.

!!! info "Two terminals needed"
    Your FastAPI server must stay running while you test with `curl`. Open a **second terminal window** (or tab) for the `curl` commands below. Keep the server terminal visible so you can see incoming request logs.

    - **Terminal 1:** Running `uvicorn main:app --reload` (do not close this)
    - **Terminal 2:** Where you type `curl` commands

### 4.2 Test the health endpoint

```bash
curl http://localhost:8000/health
```

Expected response:

```json
{"status":"healthy"}
```

To get nicely formatted (pretty-printed) output, pipe through `python3 -m json.tool`:

```bash
curl -s http://localhost:8000/health | python3 -m json.tool
```

### 4.3 Create a mood entry

=== "macOS / Linux / Git Bash"

    ```bash
    curl -X POST http://localhost:8000/mood \
      -H "Content-Type: application/json" \
      -d '{"score": 7, "note": "good day"}'
    ```

=== "Windows (PowerShell)"

    ```powershell
    curl -X POST http://localhost:8000/mood `
      -H "Content-Type: application/json" `
      -d '{"score": 7, "note": "good day"}'
    ```

Let us break this command down:

| Part | Meaning |
|------|---------|
| `-X POST` | Use the HTTP POST method (instead of the default GET) |
| `-H "Content-Type: application/json"` | Set a **header** telling the server the body is JSON |
| `-d '{"score": 7, "note": "good day"}'` | The request **body** (the data you are sending) |

Expected response:

```json
{"score":7,"note":"good day"}
```

Add a few more entries:

=== "macOS / Linux / Git Bash"

    ```bash
    curl -X POST http://localhost:8000/mood \
      -H "Content-Type: application/json" \
      -d '{"score": 4, "note": "stressful morning"}'

    curl -X POST http://localhost:8000/mood \
      -H "Content-Type: application/json" \
      -d '{"score": 9, "note": "great workout"}'
    ```

=== "Windows (PowerShell)"

    ```powershell
    curl -X POST http://localhost:8000/mood `
      -H "Content-Type: application/json" `
      -d '{"score": 4, "note": "stressful morning"}'

    curl -X POST http://localhost:8000/mood `
      -H "Content-Type: application/json" `
      -d '{"score": 9, "note": "great workout"}'
    ```

### 4.4 Retrieve all mood entries

```bash
curl http://localhost:8000/moods
```

Expected response:

```json
[{"score":7,"note":"good day"},{"score":4,"note":"stressful morning"},{"score":9,"note":"great workout"}]
```

Pretty-printed:

```bash
curl -s http://localhost:8000/moods | python3 -m json.tool
```

### 4.5 What happens with invalid data?

Try sending an entry with a missing field:

=== "macOS / Linux / Git Bash"

    ```bash
    curl -X POST http://localhost:8000/mood \
      -H "Content-Type: application/json" \
      -d '{"score": 5}'
    ```

=== "Windows (PowerShell)"

    ```powershell
    curl -X POST http://localhost:8000/mood `
      -H "Content-Type: application/json" `
      -d '{"score": 5}'
    ```

FastAPI will return a `422 Unprocessable Entity` error with details about what went wrong. This automatic validation is one of FastAPI's key strengths.

### 4.6 Quick curl reference

| Flag | Purpose | Example |
|------|---------|---------|
| `-X` | Set HTTP method | `-X POST`, `-X DELETE` |
| `-H` | Add a header | `-H "Content-Type: application/json"` |
| `-d` | Send data in the request body | `-d '{"key": "value"}'` |
| `-s` | Silent mode (hide progress bar) | `curl -s http://...` |
| `-v` | Verbose (show full request/response headers) | `curl -v http://...` |
| `-i` | Include response headers in output | `curl -i http://...` |

### Self-Check: Part 4

- [ ] You successfully posted a mood entry with `curl` and received a JSON response.
- [ ] You retrieved all entries with `GET /moods` and saw the entries you created.
- [ ] You triggered a `422` error by sending invalid data and can explain why it happened.
- [ ] You can explain what the `-X`, `-H`, and `-d` flags do in a curl command.

---

## Individual Assignment

**Deadline:** Before the start of Week 3 lab.

### Task

1. **Fork** the instructor's `mood-tracker-api` repository on GitHub (the instructor will share the URL during the lab session or on the course page).
2. **Clone** your fork locally.
3. Create a **new branch** for your feature (e.g., `feature-average-endpoint`).
4. **Add a new endpoint** to `main.py`. Choose one:
   - `GET /moods/average` — returns the average mood score, e.g., `{"average": 6.67}`.
   - `DELETE /moods/{index}` — deletes the mood entry at a given index and returns the deleted entry.
   - `GET /moods/best` — returns the mood entry with the highest score.
   - Or propose your own endpoint (clear it with your instructor first).
5. **Test** your endpoint with `curl` and make sure it works.
6. **Commit** your changes with a clear commit message.
7. **Push** your branch to your fork on GitHub.
8. Open a **Pull Request** from your fork's feature branch to the instructor's original repository.
   - In the PR description, include:
     - What the new endpoint does.
     - An example `curl` command to test it.
     - The expected response.

### Grading criteria

| Criterion | Points |
|-----------|--------|
| Branch created and named properly | 1 |
| New endpoint works correctly | 3 |
| Endpoint tested with curl (example in PR description) | 1 |
| Clean commit message(s) | 1 |
| Pull Request is well-described | 2 |
| Code quality (type hints, clear variable names) | 2 |
| **Total** | **10** |

---

## Recap

| Topic | Key commands / concepts |
|-------|------------------------|
| Branching | `git branch`, `git switch -c`, `git merge` |
| Conflicts | `<<<<<<<`, `=======`, `>>>>>>>` markers; manual resolution |
| Pull Requests | Push branch, open PR on GitHub, review, merge, `git pull` |
| Virtual env | `python -m venv venv`, `source venv/bin/activate` |
| FastAPI | `FastAPI()`, `@app.get()`, `@app.post()`, Pydantic models |
| Running | `uvicorn main:app --reload`, Swagger at `/docs` |
| curl | `-X`, `-H`, `-d` flags; GET, POST methods |

---

## Troubleshooting

??? question "`python: command not found` or `python3: command not found`"
    Python may not be installed or not on your PATH. On macOS/Linux, try `python3` instead of `python`. On Windows, install Python from [python.org](https://www.python.org/downloads/) and make sure to check **"Add Python to PATH"** during installation.

??? question "`pip install` fails with a permissions error"
    Make sure your virtual environment is activated (you should see `(venv)` in your prompt). If you see `Permission denied`, you are probably installing into the system Python instead of the venv. Run `deactivate`, then re-activate with `source venv/bin/activate` (macOS/Linux) or `source venv/Scripts/activate` (Windows Git Bash).

??? question "Port 8000 is already in use"
    Another process is using port 8000. Either stop it, or run uvicorn on a different port: `uvicorn main:app --reload --port 8001`. Update your curl commands to use the new port number.

??? question "`curl: (7) Failed to connect to localhost port 8000: Connection refused`"
    Your FastAPI server is not running. Open a **separate terminal**, navigate to the `mood-api` folder, activate the venv, and run `uvicorn main:app --reload`. Keep this terminal open while testing with curl in another terminal.

??? question "Merge conflict markers are still in the file after I edited it"
    Make sure you removed **all three marker lines** (`<<<<<<<`, `=======`, `>>>>>>>`). The file should contain only the content you want to keep, with no conflict markers remaining. After editing, run `git add patient_info.txt && git commit -m "Resolve conflict"`.

??? question "`git push` asks for a username and password"
    You are using HTTPS instead of SSH. Either set up SSH keys (see Week 1 lab) or switch the remote URL: `git remote set-url origin git@github.com:username/repo.git`.

---

## Further Reading

- [Git Branching — official documentation](https://git-scm.com/book/en/v2/Git-Branching-Branches-in-a-Nutshell)
- [GitHub Pull Requests documentation](https://docs.github.com/en/pull-requests)
- [FastAPI official tutorial](https://fastapi.tiangolo.com/tutorial/)
- [curl manual](https://curl.se/docs/manual.html)
