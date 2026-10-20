# Bugema Linux Open-Source Project — Assignments 2, 3 and 4

**Student:** NAMBALIRWA JOVIA
**Registration Number:** 24/BCC/BU/R/0003
**Programme:** Bachelor of Computer Science (BCC)
**Course:** Open-Source Systems and Linux Development
**GitHub:** [Jovian-hub](https://github.com/Jovian-hub)

This repository contains the written deliverables for the three connected practical
assignments on the [Bugema Linux](https://github.com/bos-com/bugema-linux) project.

---

## Quick links to the GitHub evidence

| Item | Link |
| --- | --- |
| Fork used for the contribution | <https://github.com/Jovian-hub/bugema-linux> |
| Issue — Assignment 3 | <https://github.com/bos-com/bugema-linux/issues/18> |
| Pull Request — Assignment 2 | <https://github.com/bos-com/bugema-linux/pull/19> |
| Contribution branch | <https://github.com/Jovian-hub/bugema-linux/tree/docs/jovian-ambalirwa-development-environment-guide> |
| Commit `7bdd394` | <https://github.com/Jovian-hub/bugema-linux/commit/7bdd394f806faeb2f4f8336ec36f7e96a7c1ba58> |
| Peer review on PR #13 | <https://github.com/bos-com/bugema-linux/pull/13#pullrequestreview-5589224757> |
| Peer review on PR #16 | <https://github.com/bos-com/bugema-linux/pull/16#pullrequestreview-5589226119> |
| Peer review on PR #17 | <https://github.com/bos-com/bugema-linux/pull/17#pullrequestreview-5589236968> |

---

## Contents

| File | Contents |
| --- | --- |
| [`ASSIGNMENT-2-GIT-WORKFLOW.md`](ASSIGNMENT-2-GIT-WORKFLOW.md) | Assignment 2: deliverables, the contribution, every Git command used, the pull request content, the peer review evidence, the response to review, the final status, and the reflection answering all six reflection questions |
| [`ASSIGNMENT-3-ISSUE-MANAGEMENT.md`](ASSIGNMENT-3-ISSUE-MANAGEMENT.md) | Assignment 3: issue type and justification, problem statement, proposed solution, testing procedure, acceptance criteria, why it matters, the link from issue to pull request, and the reflection answering all five reflection questions |
| [`ASSIGNMENT-4-DEV-ENVIRONMENT-REPORT.md`](ASSIGNMENT-4-DEV-ENVIRONMENT-REPORT.md) | Assignment 4: the full development environment report in the seventeen sections required by the handout, with the verification results, the troubleshooting table, and the appendices |
| [`docs/development-environment-setup.md`](docs/development-environment-setup.md) | The contribution itself, as submitted in pull request #19 |
| [`evidence/`](evidence/) | The verification transcript and the exact text submitted to GitHub (issue body, pull request body, the three peer reviews, the pull request comment) |
| [`scripts/`](scripts/) | The environment build script, the evidence collection scripts, the parallel downloader, and the console screenshot tool |

---

## The contribution in one paragraph

`docs/development/development-environment-setup.md` adds a contributor-facing guide
that takes a new contributor from an empty computer to a **verified** Bugema Linux
development environment, and ties every step to the architectural decisions the project
has already accepted — Ubuntu 26.04 LTS (ADR-001), Xfce 4.20 (ADR-002), APT and `.deb`
packaging (ADR-003), offline-first operation (ADR-004), and credentials held in the
operating system keyring rather than in a plaintext file (ADR-005). The project
structure in `README.md` already lists `docs/development/`; before this contribution
that directory did not exist, and `CONTRIBUTING.md` assumed a working development
environment that was documented nowhere.

---

## Note on the remaining manual work

The virtual machine could not be booted in the time available, because the network link
on the host delivered between 0.3 KB/s and 0.9 MB/s for the duration of the assignment
and the Ubuntu 26.04.1 desktop image alone is 6.5 GB. The virtualisation platform
(QEMU 8.2.2 with KVM acceleration) was installed and verified, the virtual machine is
fully specified with the exact creation and boot commands, and every verification
command that could be run on a real Linux system was run and its real output is
recorded in `evidence/host-verification.txt`. Section 14.3 of the Assignment 4 report
lists the exact remaining steps to execute manually, and the scripts in `scripts/`
perform them unattended. No output in any document was invented — where something was
not executed, the report says so.
