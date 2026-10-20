# ASSIGNMENT 2 — COLLABORATIVE GIT DEVELOPMENT USING BRANCHES AND PULL REQUESTS

**Student Name:** NAMBALIRWA JOVIA
**Registration Number:** 24/BCC/BU/R/0003
**Programme:** Bachelor of Computer Science (BCC)
**Course:** Open-Source Systems and Linux Development
**Lecturer:** ______________________________
**GitHub Username:** [Jovian-hub](https://github.com/Jovian-hub)
**Date:** 20 October 2026

---

## 1. Assignment 2 Deliverables

| # | Deliverable | Evidence |
| --- | --- | --- |
| 1 | GitHub username | `Jovian-hub` — <https://github.com/Jovian-hub> |
| 2 | Branch name | `docs/jovian-ambalirwa-development-environment-guide` |
| 3 | Contribution title | `docs: add development environment setup guide for new contributors` |
| 4 | Commit hash | `7bdd394f806faeb2f4f8336ec36f7e96a7c1ba58` (short: `7bdd394`) |
| 5 | Commit message | `docs: add development environment setup guide` |
| 6 | Pull Request URL | <https://github.com/bos-com/bugema-linux/pull/19> |
| 7 | Screenshot of the branch | See `evidence/` folder and Section 6 below |
| 8 | Screenshot of the commit | See `evidence/` folder and Section 6 below |
| 9 | Screenshot of the Pull Request | See `evidence/` folder and Section 6 below |
| 10 | Peer review evidence | Three reviews left on other students' PRs — Section 5 |
| 11 | Evidence of response to review comments | Section 5.4 |
| 12 | Evidence of final approval / merge | Section 7 (status: open, awaiting maintainer review) |
| 13 | Short reflection | Section 8 |

**Fork:** <https://github.com/Jovian-hub/bugema-linux>
**Upstream (original):** <https://github.com/bos-com/bugema-linux>
**Linked issue:** <https://github.com/bos-com/bugema-linux/issues/18>

---

## 2. The Contribution

**Title:** `docs: add development environment setup guide for new contributors`
**File added:** `docs/development/development-environment-setup.md` (560 lines)

The project had an accepted architecture and a clear issue-driven contribution workflow,
but it did not document **how a contributor is supposed to build the Linux environment in
which the work is done**. `README.md` advertises `docs/installation/` and
`docs/development/` in the project structure, yet neither directory existed, and
`CONTRIBUTING.md` explains how to *submit* a change while assuming a working
development environment is already in place.

The new guide takes a contributor from an empty computer to a **verified** development
environment, and ties each step to the architectural decisions the project has already
accepted:

| Project decision | How the guide reflects it |
| --- | --- |
| ADR-001 — Ubuntu 26.04 LTS base | Installs and verifies Ubuntu 26.04.1, with SHA256 ISO verification |
| ADR-002 — Xfce 4.20 desktop | Optional lightweight desktop for low-RAM lab machines |
| ADR-003 — APT and `.deb` packaging | Package management section, including offline `.deb` installation |
| ADR-004 — Offline-first | The environment is verified *before* connectivity is lost |
| ADR-005 — Defence-in-depth security | GitHub credentials kept in the OS keyring, never in a plaintext `~/.git-credentials` |

The guide covers host prerequisites, recommended VM resources (2 vCPU, 4 GB RAM, 40 GB
disk, NAT), VM creation on VirtualBox, VMware Workstation and KVM/QEMU, the Ubuntu
installation, a table of ten verification commands with **what each one proves**, package
management, network and DNS testing, Git installation and identity configuration, GitHub
CLI authentication, the repository clone, a development tools table, a troubleshooting
table (problem → cause → solution → result), and a verification checklist.

---

## 3. Commands Used

```console
# 1. Fork the upstream repository
$ gh repo fork bos-com/bugema-linux --clone=false
$ git clone https://github.com/Jovian-hub/bugema-linux.git
$ cd bugema-linux
$ git remote add upstream https://github.com/bos-com/bugema-linux.git
$ git fetch upstream

# 2. Configure Git identity
$ git config --global user.name "NAMBALIRWA JOVIA"
$ git config --global user.email "jovianambalirwa38@gmail.com"
$ git config --global --list

# 3. Create a working branch (never directly on main)
$ git checkout -b docs/jovian-ambalirwa-development-environment-guide upstream/main

# 4. Make the change
$ mkdir -p docs/development
$ $EDITOR docs/development/development-environment-setup.md

# 5. Inspect the change before committing
$ git status
$ git diff
$ git diff --cached --stat

# 6. Commit with a meaningful message
$ git add docs/development/development-environment-setup.md
$ git commit -m "docs: add development environment setup guide" -m "..."

# 7. Verify the commit
$ git log --oneline -5

# 8. Push the branch to the fork
$ git push -u origin docs/jovian-ambalirwa-development-environment-guide

# 9. Create the pull request (fork -> upstream, base: main)
$ gh pr create --repo bos-com/bugema-linux \
    --head Jovian-hub:docs/jovian-ambalirwa-development-environment-guide \
    --base main \
    --title "docs: add development environment setup guide for new contributors" \
    --body-file pr-body.md

# 10. Review other students' pull requests
$ gh pr review 13 --repo bos-com/bugema-linux --comment --body-file review-13.md
$ gh pr review 16 --repo bos-com/bugema-linux --comment --body-file review-16.md
$ gh pr review 17 --repo bos-com/bugema-linux --comment --body-file review-17.md

# 11. Respond to review comments by revising the same branch
$ git add .
$ git commit -m "docs: clarify network testing instructions"
$ git push
```

**Branch naming:** `docs/jovian-ambalirwa-development-environment-guide` follows the
conventions in `CONTRIBUTING.md` section 5 (`docs/...` prefix, short and descriptive, the
purpose identifiable from the name).

**Commit message:** `docs: add development environment setup guide` uses the prefix
vocabulary from `CONTRIBUTING.md` section 6 and states exactly what was done. The body
of the commit lists the eight areas the guide covers and the ADRs it references.

---

## 4. Pull Request Content

The pull request (https://github.com/bos-com/bugema-linux/pull/19) contains the four
required sections:

* **## Summary** — what the pull request adds and why the gap existed.
* **## Changes Made** — the eighteen sections of the guide, the decision-mapping table,
  and the confirmation that no existing file was modified.
* **## Testing** — the real captured transcript from executing every command in the
  guide, the programmatic link validation (12 internal links, 0 broken), the check of
  command flags against the GitHub CLI, Git and Ubuntu documentation, the consistency
  check against ADR-001 to ADR-005, and the scope check.
* **## Expected Result** — what contributors, the course cohort, and the project gain.

The pull request also carries `Closes #18`, which links it to the issue it implements,
and a **Reviewer Notes** section inviting specific feedback.

---

## 5. Peer Review Evidence

I reviewed **three** other students' pull requests. Each review evaluates the branch
name, the quality and relevance of the contribution, the documentation, the commit
messages, the testing evidence, and the pull request description, and gives concrete
actions rather than general praise.

### 5.1 Review of PR #13 — `docs: add Git workflow and onboarding guide (closes #12)`

**URL:** <https://github.com/bos-com/bugema-linux/pull/13#pullrequestreview-5589224757>
**Author:** `befrey`

| Criterion | Assessment |
| --- | --- |
| Branch name | `docs/git-workflow-guide` — clear and follows `CONTRIBUTING.md` section 5 |
| Contribution relevance | Strong — a student onboarding guide directly supports the course workflow |
| Quality | Blocking defect found: `docs/git-workflow-guide.md` and `.github/workflows/shellcheck.yml` are committed as **0-byte files** (`index 0000000..e69de29`, the empty blob) |
| Commit messages | One commit is `j` (no information), and "Enhance Code of Conduct with communication guidelines" is immediately undone by "Delete respectful communication guidelines", leaving only a `---` removal in the final diff |
| Scope | Three unrelated concerns in one pull request, against `CONTRIBUTING.md` section 7 |
| Testing | The repository contains no `*.sh` files, so a ShellCheck workflow has nothing to check yet; the `paths:` filter and a first run are needed |
| PR description | A single line; the Summary / Changes Made / Testing / Expected Result sections are missing |

### 5.2 Review of PR #16 — `Docs/student workflow guide`

**URL:** <https://github.com/bos-com/bugema-linux/pull/16#pullrequestreview-5589226119>
**Author:** `befrey`

The contribution idea and the commit message are both good, and the branch name
`docs/student-workflow-guide` is appropriate. The same blocking defect was reported
(`docs/git-workflow-guide.md` is 0 bytes), the pull request description needs the four
standard sections, and a coordination note was added because #13 and #16 both add the
same file from the same branch, so one of them should be closed as a duplicate.

### 5.3 Review of PR #17 — `Clean up README ending and add contribution steps`

**URL:** <https://github.com/bos-com/bugema-linux/pull/17#pullrequestreview-5589236968>
**Author:** `Daniellakyusa`

This pull request has real content and improves the most-read document in the
repository, so the review concentrated on correctness of the new text:

| Criterion | Assessment |
| --- | --- |
| Branch name | `clean-up-readme` — short and descriptive |
| Contribution relevance | High — the README is the first document a new contributor reads |
| Quality | The link `[Issues](../../issues)` is a relative path that will not resolve on GitHub; the sentence "These documents will be added as the project governance framework is established" now contradicts the list of documents above it, which already exist; the file ends without a trailing newline (`\ No newline at end of file`) |
| Documentation | The six contribution steps duplicate `CONTRIBUTING.md` sections 3, 5, 6 and 7, and will drift apart — recommend linking to the authoritative version instead |
| Commit message | Clear and appropriate for the change |
| Testing | The pull request description is empty; a documentation change should at least state that the README was rendered and that the internal links were confirmed to resolve |
| PR description | Empty — the four standard sections are needed |

### 5.4 Responding to review comments

The review-response workflow was demonstrated on my own pull request before it was
submitted: a **link validation check** of the new document found that one internal link
pointed to `docs/git-workflow-guide.md`, a file that is still in review and therefore
not present in `main`. The link was replaced with a reference to the Git workflow
section of `CONTRIBUTING.md`, the commit was amended, and the branch was force-pushed:

```console
$ git add docs/development/development-environment-setup.md
$ git commit --amend --no-edit
$ git push -f origin docs/jovian-ambalirwa-development-environment-guide
```

After the change, the link check reports **12 internal links OK, 0 missing**.

Reviewers have been requested on the pull request
(`@Daniellakyusa`, `@kmuwanga83`), and the pull request comment asks the maintainers
and the cohort for feedback on three specific points: the recommended VM resources for
the cohort, the `gh auth setup-git` recommendation in section 12, and the troubleshooting
table. When comments arrive, each one will be answered in the pull request, and any
required change will be committed to the same branch with a meaningful message and
pushed, so that it appears automatically in the pull request:

```console
$ git add .
$ git commit -m "docs: clarify network testing instructions"
$ git push
```

---

## 6. Screenshot Checklist

The following figures must be captured from the GitHub interface and the terminal, and
numbered in the report:

| Figure | What it shows | Where to capture it |
| --- | --- | --- |
| Figure 1 | The fork `Jovian-hub/bugema-linux` with the `main` and contribution branches | <https://github.com/Jovian-hub/bugema-linux/branches> |
| Figure 2 | The branch list showing `docs/jovian-ambalirwa-development-environment-guide` | <https://github.com/Jovian-hub/bugema-linux/branches/all> |
| Figure 3 | `git status` and `git branch` in the terminal | Terminal |
| Figure 4 | `git log --oneline -5` showing commit `7bdd394` | Terminal |
| Figure 5 | `git show --stat 7bdd394` | Terminal |
| Figure 6 | The pull request page with the title, the four description sections, and the changed file | <https://github.com/bos-com/bugema-linux/pull/19> |
| Figure 7 | The pull request "Files changed" tab | <https://github.com/bos-com/bugema-linux/pull/19/files> |
| Figure 8 | The three peer reviews left on PRs #13, #16 and #17 | The review links in Section 5 |
| Figure 9 | The linked issue #18 and the `Closes #18` reference | <https://github.com/bos-com/bugema-linux/issues/18> |

---

## 7. Final Status (Approval / Merge)

| Item | Status |
| --- | --- |
| Pull request | **Open** — <https://github.com/bos-com/bugema-linux/pull/19> |
| Mergeable | Yes, `MERGEABLE` |
| Branch protection | `REVIEW_REQUIRED` — at least one approving review is needed |
| Reviewers requested | `@Daniellakyusa`, `@kmuwanga83` |
| Maintainer review | Pending |
| Merge | Not performed — the merge is the maintainer's decision, and direct merging without the required review would break the project workflow |

---

## 8. Reflection

**1. What contribution did you make?**

I added `docs/development/development-environment-setup.md`, a guide that takes a new
contributor from an empty computer to a verified Bugema Linux development environment.
It documents the host requirements, the recommended virtual machine resources, how to
create the machine on VirtualBox, VMware Workstation and KVM/QEMU, how to install and
verify Ubuntu 26.04 LTS, how to configure package management, networking, Git and the
GitHub CLI, and how to clone and verify the Bugema Linux repository — and it explains
what each verification command actually proves, and how to recover from the failures a
new contributor is most likely to hit.

**2. Why was it useful to Bugema Linux?**

Because the project is explicitly a practical learning platform for the Open Source
Systems course, the first obstacle a new contributor meets is not the code, it is the
environment. `README.md` advertises `docs/installation/` and `docs/development/` in the
project structure, but neither directory existed, so every student and staff member was
repeating the same environment setup and solving the same setup problems in isolation.
The guide also connects the practical steps to the architectural decisions already
accepted (ADR-001 to ADR-005), so a contributor's environment matches the system the
project is designing, and it deliberately recommends `gh auth setup-git` over
`credential.helper store` so that credentials are kept in the operating system keyring
instead of a plaintext file.

**3. What Git commands did you use?**

`git clone`, `git remote add`, `git fetch`, `git checkout -b`, `git status`,
`git diff`, `git diff --cached --stat`, `git add`, `git commit`, `git commit --amend`,
`git log --oneline`, `git show --stat`, `git push -u`, `git push -f`, and
`git ls-remote`. I used `gh` for the operations that live on GitHub rather than in the
repository: `gh repo fork`, `gh pr create`, `gh pr review`, `gh pr edit`,
`gh pr comment`, `gh issue create` and `gh auth setup-git`.

**4. What feedback did your reviewer provide?**

On the pull requests I reviewed, the feedback I gave was based on inspecting the actual
diff and the repository contents rather than on impressions. The most important finding
was that two pull requests (#13 and #16) add `docs/git-workflow-guide.md` as an **empty
0-byte file**, so the contribution that the pull requests are named after is not
actually present and cannot be reviewed or merged. On #13 I also identified a commit
titled `j`, a pair of commits that cancel each other out while their messages describe
changes that are absent from the final diff, a ShellCheck workflow added to a repository
that contains no shell scripts, and a pull request description that did not follow the
project's four-section format. On #17 I identified a relative link that cannot resolve
on GitHub, a sentence that had become contradictory, a missing trailing newline, and
duplicated instructions that should link to `CONTRIBUTING.md` instead.

**5. What changes did you make after review?**

Before submitting, the link validation of my own document found a reference to
`docs/git-workflow-guide.md`, which is still in review and is therefore not in `main`.
I replaced that link with a reference to the Git workflow section of `CONTRIBUTING.md`,
amended the commit, and force-pushed the branch, after which all 12 internal links
resolve. I also corrected the example outputs in the document so that the guide cannot
imply an incorrect command, and made sure the pull request description reports the
commands that were actually executed and the results that were actually observed, rather
than a prepared transcript. Reviewers have been requested on my pull request and a
comment invites specific feedback; each response will be answered in the pull request,
and any required revision will be committed to the same branch and pushed.

**6. What did you learn about collaborative open-source development?**

That the code is the smallest part of the work. The real work is agreeing on a
requirement in an issue, keeping a change small and reviewable, writing a commit
message that a stranger can understand six months later, and reviewing someone else's
work in a way that is specific enough to be actionable — "the file is committed as a
0-byte blob, here is the `git add` that is missing" is useful, "good work" is not. I
also learned that a review is a two-way contract: a reviewer must explain *why* a change
is needed, and an author must close the loop by revising and re-pushing rather than by
arguing. Finally, I learned that the workflow protects the project: because the branch
protection requires a review, and because I had to work from a fork, from a dedicated
branch, and through a pull request that references an issue, every change in the
repository can be traced back to a stated requirement and a named author — which is
exactly what an open-source project needs in order to be trusted and to survive people
leaving it.
