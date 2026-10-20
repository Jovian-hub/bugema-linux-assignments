# ASSIGNMENT 3 — IDENTIFYING, DOCUMENTING AND MANAGING OPEN-SOURCE PROJECT ISSUES

**Student Name:** NAMBALIRWA JOVIA
**Registration Number:** 24/BCC/BU/R/0003
**Programme:** Bachelor of Computer Science (BCC)
**Course:** Open-Source Systems and Linux Development
**Lecturer:** ______________________________
**GitHub Username:** [Jovian-hub](https://github.com/Jovian-hub)
**Date:** 20 October 2026

---

## 1. Assignment 3 Deliverables

| # | Deliverable | Evidence |
| --- | --- | --- |
| 1 | Issue URL | <https://github.com/bos-com/bugema-linux/issues/18> |
| 2 | Issue number | **#18** |
| 3 | Issue type | **Documentation issue** (`[DOCS]`) — raised through the repository's *Student Contribution Proposal* template |
| 4 | Screenshot of the issue | See `evidence/` folder and Section 8 |
| 5 | Problem statement | Section 3.1 |
| 6 | Proposed solution | Section 3.2 |
| 7 | Testing procedure | Section 3.3 |
| 8 | Acceptance criteria | Section 3.4 |
| 9 | Why the issue matters | Section 3.5 and Section 5 |
| 10 | Proposed branch name | `docs/jovian-ambalirwa-development-environment-guide` |

**Issue title:**
`[STUDENT] Contribution Proposal - [DOCS] Development environment setup guide for new contributors - NAMBALIRWA JOVIA`

The issue was raised on the upstream project, `bos-com/bugema-linux`, so that the
maintainers and the whole cohort can see the requirement. The implementation that
follows from it is the pull request
<https://github.com/bos-com/bugema-linux/pull/19>, which carries `Closes #18`.

---

## 2. Issue Type and Why

**Type selected: Documentation issue (C).**

* It is not a **bug**: no existing component of Bugema Linux fails to work. The
  repository's scripts, configuration, and documentation all behave as intended.
* It is not a **feature**: it introduces no new program, no new capability, and no new
  build target. It does not change what the project does.
* It is a **documentation issue**: a required document — the one that tells a
  contributor how to build the environment in which the work is done — is **missing**,
  while the project structure in `README.md` already claims that it exists.

The issue was raised through the repository's own
`.github/ISSUE_TEMPLATE/student_contribution.md` template, because the project has
provided that template specifically for contributions from the Open Source Systems
course. The template fields are filled in, and the sections the assignment requires
(Problem, Background, Proposed Solution, Testing, Acceptance Criteria) are included
inside it.

---

## 3. The Issue

### 3.1 Problem statement

> Bugema Linux has an accepted system architecture and a clear contribution workflow, but
> it does not yet document how a contributor is supposed to build the Linux environment
> in which the work is done.
>
> The project structure advertised in `README.md` lists `docs/installation/` and
> `docs/development/`, yet neither directory exists in the repository. The only
> contributor documentation currently available is `CONTRIBUTING.md`, which explains how
> to *submit* a change but assumes that the contributor already has a working Linux
> development environment with Git and GitHub access.
>
> As a result, a new student or staff member who has just joined the project faces a
> series of undocumented, repeated decisions: which Linux distribution and version to
> install (the project is based on Ubuntu 26.04 LTS per ADR-001, but this is not
> repeated in the contribution instructions); which virtualisation platform to use and
> how to size the virtual machine; how to verify that the installation, networking,
> package management and Git are all working before the first commit; and how to
> authenticate to GitHub without writing credentials to disk in clear text, which is
> contrary to the requirements of ADR-005.
>
> Every student therefore repeats the same setup work, and every setup problem is solved
> independently and in isolation instead of once for the whole community.

### 3.2 Proposed solution

Add a single contributor-facing guide, `docs/development/development-environment-setup.md`,
that walks a new contributor from an empty computer to a verified, working Bugema Linux
development environment:

1. **Prerequisites** — host requirements and how to confirm hardware virtualisation is
   available.
2. **Recommended virtual machine resources** — 2 vCPU, 4 GB RAM, 40 GB disk, NAT,
   64-bit, with the reasoning for each value and an Xfce fallback for low-RAM hosts.
3. **Supported virtualisation platforms** — VirtualBox, VMware Workstation and
   KVM/QEMU, with equivalent instructions for each.
4. **Obtaining and verifying the Ubuntu 26.04.1 ISO**, including SHA256 checksum
   verification.
5. **Creating the virtual machine** — step-by-step instructions for each platform.
6. **Installing Ubuntu 26.04 LTS** — installer walkthrough, disk configuration, user
   creation, first boot, guest utilities, and the optional Xfce 4.20 desktop.
7. **Verifying the installation** — a table of ten commands (`whoami`, `id`, `hostname`,
   `hostnamectl`, `uname -a`, `lsb_release -a`, `free -h`, `df -h /`,
   `systemd-detect-virt`) with an explanation of what each one proves.
8. **Package management** — `apt update`, `apt upgrade`, `apt install`, and the offline
   `.deb` workflow required by ADR-004.
9. **Networking** — `ip addr`, `ip route`, `ping -c 4 8.8.8.8`, `ping -c 4 github.com`,
   DNS inspection, and how to read NAT addressing.
10. **Git installation and configuration**, including identity configuration and the
    requirement to use the same email address registered on GitHub.
11. **GitHub CLI authentication** — `gh auth login` and `gh auth setup-git`, with an
    explicit explanation of why `credential.helper store` (plaintext
    `~/.git-credentials`) must be avoided in line with ADR-005.
12. **Cloning the Bugema Linux repository** and confirming the clone with `git status`,
    `git log --oneline -5` and `git branch -a`.
13. **Development tools reference** — table of tools, version commands and purposes.
14. **Troubleshooting table** — problem, cause, solution and result for the failures a
    new contributor is most likely to hit.
15. **A development environment verification checklist** covering the whole workflow.

The guide links back to `CONTRIBUTING.md`, `docs/architecture/system-architecture.md` and
the relevant ADRs, so that it complements the existing documentation instead of
duplicating it.

### 3.3 Testing procedure

1. **Environment build** — create a virtual machine on the documented configuration
   (2 vCPU, 4 GB RAM, 40 GB disk, NAT) and install Ubuntu 26.04 LTS.
2. **Command verification** — every command in the guide is executed in the built
   environment and the output is compared with the table in the guide. Any command whose
   documented output does not match reality is corrected before the pull request is
   submitted.
3. **Reproducibility** — a second contributor who has not previously configured a Linux
   virtual machine follows the guide from the beginning and must reach a working
   environment with Git configured, GitHub CLI authenticated, and the Bugema Linux
   repository cloned.
4. **Command correctness** — the commands are checked against the
   [GitHub CLI manual](https://cli.github.com/manual/), the
   [Git documentation](https://git-scm.com/doc/) and the
   [Ubuntu documentation](https://docs.ubuntu.com/) to confirm that flags, paths and
   expected output are current.
5. **Link validation** — every internal link is confirmed to resolve to an existing file
   in the repository.

**Result of the testing already carried out:** the guide was written and validated on a
live Ubuntu system, the 12 internal links were resolved programmatically with no
missing target, and the commands, flags and expected outputs were checked against the
upstream documentation. The environment build itself is documented in the Assignment 4
report.

### 3.4 Acceptance criteria

```text
[ ] The host prerequisites and how to confirm hardware virtualisation are documented.
[ ] The recommended VM resources (CPU, RAM, storage, network, architecture) are documented with reasons.
[ ] At least two virtualisation platforms are documented, with equivalent instructions.
[ ] The Ubuntu 26.04.1 ISO download and SHA256 checksum verification are documented.
[ ] VM creation is documented step by step.
[ ] The Ubuntu installation, including disk configuration and user creation, is documented.
[ ] A table of verification commands is included, stating what each command proves.
[ ] Package management with APT is documented, including the offline .deb workflow (ADR-003, ADR-004).
[ ] Network configuration and connectivity testing, including DNS testing, are documented.
[ ] Git installation and identity configuration are documented.
[ ] GitHub CLI authentication is documented, with the reason for avoiding plaintext credential files (ADR-005).
[ ] Cloning the Bugema Linux repository and confirming the clone are documented.
[ ] A development tools table is included.
[ ] A troubleshooting table with problem, cause, solution and result is included.
[ ] A development environment verification checklist is included.
[ ] Every internal link resolves to a file that exists in the main branch.
[ ] Another student can reproduce the setup from the guide alone.
```

### 3.5 Why the issue matters

* **It is the entry point to the contribution workflow.** The project workflow in
  `README.md` and `CONTRIBUTING.md` begins with *Issue → Branch → Development → Testing
  → Pull Request → Review → Merge*. The first step cannot be completed smoothly without
  a documented, reproducible development environment.
* **The project's purpose is teaching.** Bugema Linux is explicitly an institutional
  open-source project and a practical learning platform for students. The students are
  the first users of this environment, so they are the first people who need it
  documented.
* **It removes duplicated work.** Without the guide, every student and every new staff
  member repeats the same setup and solves the same problems alone.
* **It closes a documented gap.** `README.md` lists `docs/installation/` and
  `docs/development/` in the project structure; those directories did not exist. The
  issue makes the repository match its own advertised structure.
* **It supports the Alpha 0.1 milestone.** The milestone already lists "Git", "Python",
  "Java", "a development environment" and "basic system documentation" among its
  acceptance criteria, and asks for an installable image that can be tested in a
  virtual machine.
* **It protects credentials.** Documenting `gh auth setup-git` instead of
  `credential.helper store` keeps GitHub tokens in the operating system keyring, which
  satisfies ADR-005 and prevents every student from creating a plaintext
  `~/.git-credentials` file on a shared or backed-up machine.

---

## 4. Connecting the Issue to Development

```text
Issue #18
   ↓
Requirement: a documented, reproducible Bugema Linux development environment
   ↓
Branch: docs/jovian-ambalirwa-development-environment-guide
   ↓
Implementation: docs/development/development-environment-setup.md (560 lines)
   ↓
Testing: commands executed, links resolved, flags checked against upstream documentation
   ↓
Pull Request: https://github.com/bos-com/bugema-linux/pull/19  (contains "Closes #18")
   ↓
Review: peer review requested from @Daniellakyusa and @kmuwanga83
   ↓
Maintainer review and merge: pending
```

GitHub links the pull request to the issue automatically because the pull request
description contains `Closes #18`; merging the pull request will close issue #18.

---

## 5. Reflection

**1. Why is issue management important in software development?**

An issue is a written record of a requirement, and writing it down forces the
requirements to be examined before any code is written. The act of describing a problem
forces you to separate what you *observed* from what you *assume*, and it forces you to
state how the problem would be recognised as solved. It also makes the work visible to
other people: an issue is where the reasoning is recorded, where a maintainer can
redirect an approach that is heading the wrong way before it wastes effort, and where
several people can contribute to one requirement without duplicating each other's work.
Most importantly, an issue gives a change an identity. When the pull request, the
commits, the tests, and the eventual release notes all refer back to it, the history of
the project stays explainable — and in an open-source project whose contributors are
students who leave after their courses, that history is the only thing that survives.

**2. What makes my issue a genuine project requirement?**

Three things. First, it is grounded in the repository itself and not in my preference:
`README.md` advertises `docs/installation/` and `docs/development/` in the project
structure, and neither directory existed — the project had stated a need it had not met.
Second, it is demanded by the project's own architecture: ADR-001 fixes the base
distribution, ADR-002 the desktop, ADR-003 the package manager, ADR-004 the
offline-first requirement and ADR-005 the credential rules, and every one of those
decisions has a practical consequence for a contributor's workstation that was
documented nowhere. Third, it is a requirement that other people have already
encountered — the same environment setup is performed by every student in the course and
by every new member of staff. The issue was also raised through the project's own
student contribution template, and it is linked to a pull request that implements it, so
the requirement is not a document that sits unused.

**3. How would a developer implement my issue?**

In five steps. First, read the accepted ADRs and the existing contributor documentation
so that the guide is consistent with the project's decisions rather than a personal
preference. Second, choose the distribution and version from ADR-001 (Ubuntu 26.04 LTS)
and the virtualisation platforms that the cohort can actually obtain, and settle the
resource recommendations (2 vCPU, 4 GB RAM, 40 GB disk, NAT) from what the project will
have to build and test. Third, write the guide in the order the contributor performs the
tasks — host preparation, VM creation, installation, verification, package management,
networking, Git, GitHub CLI, clone, tools, troubleshooting, checklist — and explain the
reason behind each recommendation rather than only listing the clicks. Fourth, express
the verification steps as commands with the expected output and a statement of what each
command proves, so that the guide is self-checking. Fifth, validate the guide by
executing every command in a clean environment, resolving every internal link
programmatically, and checking each flag and each expected output against the upstream
Git, GitHub CLI and Ubuntu documentation before submitting the pull request.

**4. How would I test the solution?**

By building the environment the guide describes, from scratch, and by checking the
guide against what actually happens. Concretely: create the virtual machine on the
documented configuration and install Linux on it; run every command that the guide
tells the reader to run and compare the output with the documented result; confirm that
the troubleshooting table covers the failures that actually occur during the build, by
recording each problem, its cause, the solution applied, and the outcome; verify that
the repository clone succeeds and that the contributions from the guide — creating a
branch, committing, pushing, and opening a pull request — work as described; and resolve
every internal link programmatically. Finally, a second contributor who has never
configured a Linux virtual machine should follow the guide alone and reach a working
environment. That test is what separates a document that is correct from a document that
is merely present.

**5. What would constitute successful completion?**

The issue is complete when `docs/development/development-environment-setup.md` exists in
the `main` branch of `bos-com/bugema-linux` and every item on the acceptance-criteria
list in Section 3.4 is ticked: the prerequisites, the recommended resources, the
per-platform VM creation instructions, the ISO download and checksum verification, the
installation and user creation, the verification-command table, the package management
and offline `.deb` workflow, the network and DNS testing, the Git configuration, the
GitHub CLI authentication that avoids plaintext credentials, the clone verification, the
development tools table, the troubleshooting table, and the final checklist. In
addition, all internal links must resolve in `main`, and the guide must have been
followed end to end by someone other than its author, with the resulting pull request
reviewed and merged by a maintainer. The practical test of success is simple: a new
contributor should be able to go from a blank computer to a working Bugema Linux
development environment using that one document, and should never have to ask a
question that the document already answers.
