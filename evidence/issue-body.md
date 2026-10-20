## Student Information

- **Name:** NAMBALIRWA JOVIA
- **Registration Number:** 24/BCC/BU/R/0003
- **GitHub Username:** [Jovian-hub](https://github.com/Jovian-hub)

## Area of Contribution

- [ ] Linux Administration
- [ ] Desktop & Branding
- [ ] Applications
- [x] Documentation
- [ ] Testing & Quality Assurance
- [ ] Security
- [ ] DevOps / Build Automation
- [ ] Networking
- [ ] Package Management
- [ ] Research / Innovation
- [ ] Other

## Problem

Bugema Linux has an accepted system architecture and a clear contribution workflow, but it
does not yet document **how a contributor is supposed to build the Linux environment in
which the work is done**.

The project structure advertised in `README.md` lists `docs/installation/` and
`docs/development/`, yet neither directory exists in the repository. The only contributor
documentation currently available is `CONTRIBUTING.md`, which explains *how to submit* a
change but assumes that the contributor already has a working Linux development
environment with Git and GitHub access.

As a result, a new student or staff member who has just joined the project faces a
series of undocumented, repeated decisions:

- which Linux distribution and version to install (the project is based on Ubuntu 26.04 LTS
  per ADR-001, but this is not repeated in the contribution instructions);
- which virtualisation platform to use and how to size the virtual machine (CPU, RAM,
  disk, network);
- how to verify that the installation, networking, package management, and Git are all
  working before the first commit;
- how to authenticate to GitHub without writing credentials to disk in clear text, which
  is contrary to the requirements of ADR-005.

Every student therefore repeats the same setup work, and every setup problem is solved
independently and in isolation instead of once for the whole community.

## Background

Bugema Linux is an institutional open-source project whose stated purpose is to be a
**practical learning and research platform for students** taking the Open Source Systems
course. The contribution workflow in `README.md` and `CONTRIBUTING.md` is explicitly
issue-driven:

```text
Issue → Branch → Development → Testing → Pull Request → Review → Merge
```

The first step of that workflow is impossible to complete smoothly without a documented,
reproducible development environment. The project has already made the architectural
decisions that such an environment must respect:

* **ADR-001** — Ubuntu 26.04 LTS is the base distribution;
* **ADR-002** — Xfce 4.20 is the default desktop (relevant to low-resource lab machines);
* **ADR-003** — APT and `.deb` packaging;
* **ADR-004** — offline-first operation, so the environment must be verified *before* a
  contributor loses connectivity;
* **ADR-005** — defence-in-depth security, so GitHub credentials must not be stored in
  plaintext.

A single setup guide that ties these decisions together removes duplicated effort,
reduces the number of first-day problems, and gives the project a reproducible starting
point for the Alpha 0.1 milestone, whose acceptance criteria already include
"successful boot", "Git", "Python", "Java", and a "development environment".

## Proposed Solution

Add a single contributor-facing guide, `docs/development/development-environment-setup.md`,
that walks a new contributor from an empty computer to a verified, working Bugema Linux
development environment.

The guide will cover:

1. **Prerequisites** — host requirements and how to confirm hardware virtualisation is
   available.
2. **Recommended virtual machine resources** — 2 vCPU, 4 GB RAM, 40 GB disk, NAT, 64-bit,
   with the reasoning for each value and an Xfce fallback for low-RAM machines.
3. **Supported virtualisation platforms** — VirtualBox, VMware Workstation, and KVM/QEMU,
   with equivalent instructions for each.
4. **Obtaining and verifying the Ubuntu 26.04.1 ISO**, including SHA256 checksum
   verification.
5. **Creating the virtual machine** — step-by-step instructions for each platform.
6. **Installing Ubuntu 26.04 LTS** — installer walkthrough, disk configuration, user
   creation, first boot, guest utilities, and the optional Xfce 4.20 desktop.
7. **Verifying the installation** — a table of commands (`whoami`, `id`, `hostname`,
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
    `git log --oneline -5`, and `git branch -a`.
13. **Development tools reference** — table of tools, version commands, and purposes.
14. **Troubleshooting table** — problem, cause, solution, and result for the failures a
    new contributor is most likely to hit.
15. **A development environment verification checklist** covering the whole workflow.

The guide will link back to `CONTRIBUTING.md`, `docs/git-workflow-guide.md`, and the
relevant ADRs so that it complements the existing documentation instead of duplicating it.

## Testing

The guide will be tested by applying it end to end and recording the result:

1. **Environment build** — create a virtual machine on the documented configuration
   (2 vCPU, 4 GB RAM, 40 GB disk, NAT) and install Ubuntu 26.04 LTS from the official ISO.
2. **Command verification** — every command in the guide will be executed in the built
   environment and the output compared with the table in the guide. Any command whose
   documented output does not match reality will be corrected before the pull request is
   submitted.
3. **Reproducibility** — a second contributor who has not previously configured a Linux
   virtual machine will follow the guide from the beginning and must reach a working
   environment with Git configured, GitHub CLI authenticated, and the Bugema Linux
   repository cloned.
4. **Command correctness** — the commands will be checked against the
   [GitHub CLI manual](https://cli.github.com/manual/), the
   [Git documentation](https://git-scm.com/doc/), and the
   [Ubuntu documentation](https://docs.ubuntu.com/) to confirm that flags, paths, and
   expected output are current.
5. **Link validation** — every internal link will be confirmed to resolve to an existing
   file in the repository.

## Expected Outcome

* A new contributor can produce a verified Bugema Linux development environment from a
  clean computer using one document.
* Students spend their time on contributions instead of on repeated environment
  setup problems.
* The setup knowledge of the community is preserved in the repository rather than being
  held individually by each student.
* The guide gives ADR-001 to ADR-005 a concrete, practical expression for contributors.
* The project gains the "development environment" documentation that the Alpha 0.1
  milestone already expects to exist.

## Evidence of Work

* The completed guide, submitted as a pull request against `main`.
* Terminal output from the environment build recorded in the pull request description.
* The pull request linked to this issue with `Closes #<issue-number>`.
* The environment used to verify the guide is itself documented in the student's
  Assignment 4 development environment report.

## Related Bugema Linux Component

* `docs/development/` — new contributor-facing documentation (directory does not yet
  exist in the repository).
* References: `README.md` (project structure), `CONTRIBUTING.md` (contribution
  workflow), `docs/architecture/system-architecture.md`, and ADRs 001–005.

## Questions or Support Needed

* Confirmation from the maintainers that VirtualBox is the platform the cohort will be
  standardised on, so that the guide can be prioritised accordingly. The guide currently
  documents VirtualBox first, with equivalent instructions for VMware Workstation and
  KVM/QEMU.
* Guidance on whether a separate `docs/installation/` guide for end users should be
  written later, or whether installation guidance should continue to live in a single
  development-environment document for now.

## Student Declaration

I understand that I should not make direct changes to the `main` branch. I will follow the
Bugema Linux contribution workflow and submit my work for review.
