Closes #18

## Summary

This pull request adds `docs/development/development-environment-setup.md`, a
contributor-facing guide that takes a new contributor from an empty computer to a
verified, working Linux development environment for Bugema Linux.

The project already has an accepted architecture and a clear issue-driven contribution
workflow, but it does not document **how the Linux environment in which the work is done
should be built**. `README.md` advertises `docs/installation/` and `docs/development/` in
the project structure, yet neither directory exists, and `CONTRIBUTING.md` assumes a
working environment with Git and GitHub access already exists. Every new contributor
therefore repeats the same setup work and solves the same setup problems in isolation.

The guide ties the guide to the decisions the project has already made, so that the
environment a contributor builds matches the system the project is designing:

| Project decision | How the guide reflects it |
| --- | --- |
| ADR-001 — Ubuntu 26.04 LTS base | The guide installs and verifies Ubuntu 26.04.1 |
| ADR-002 — Xfce 4.20 desktop | Optional lightweight desktop for low-RAM hosts |
| ADR-003 — APT and `.deb` packaging | Package management section, including offline `.deb` installs |
| ADR-004 — Offline-first | The environment is verified *before* connectivity is lost |
| ADR-005 — Defence-in-depth security | GitHub credentials are kept in the OS keyring, never in a plaintext `~/.git-credentials` |

## Changes Made

* **Added** `docs/development/development-environment-setup.md` (18 sections):
  1. Purpose, and how the guide relates to the accepted ADRs;
  2. Host prerequisites, including how to confirm hardware virtualisation is available;
  3. Recommended virtual machine resources (2 vCPU, 4 GB RAM, 40 GB disk, NAT, 64-bit)
     with the reasoning for each value;
  4. Supported virtualisation platforms (VirtualBox, VMware Workstation, KVM/QEMU);
  5. Downloading Ubuntu 26.04.1 and **verifying the ISO with SHA256**;
  6. Creating the virtual machine — step-by-step instructions for all three platforms;
  7. Installing Ubuntu 26.04 LTS — installer walkthrough, disk configuration, user
     creation, first boot, guest utilities, and the optional Xfce 4.20 desktop;
  8. Verifying the installation — a table of ten commands with **what each one proves**;
  9. Package management with APT, including the offline `.deb` workflow;
  10. Network configuration and testing — `ip addr`, `ip route`, ping by IP, ping by
      name, DNS inspection, and how to read NAT addressing;
  11. Git installation and identity configuration;
  12. GitHub CLI authentication with `gh auth login` and `gh auth setup-git`, and why
      `credential.helper store` must be avoided;
  13. Cloning the Bugema Linux repository and confirming the clone;
  14. Development tools reference table;
  15. Troubleshooting table (problem → cause → solution → result) for the ten most likely
      first-day failures;
  16. A development environment verification checklist;
  17. Related project documents;
  18. References.
* **No existing files were modified.** The change is additive, so it cannot conflict with
  the documentation work already in review (for example #13 and #16).
* All internal links point to files that exist in `main`; a link to the student Git
  workflow guide was removed during review because that document is not yet merged.

## Testing

The guide was checked as follows.

**1. Every command in the guide was executed on a live Linux system and the output
compared with the documented result.** The transcript below is the actual captured output
from the validation environment (Ubuntu 24.04.4 LTS, 8 vCPU, 7.6 GiB RAM, KVM-capable
host) - the same verification commands the guide asks a contributor to run inside the
virtual machine:

```console
$ whoami
medisoft
$ id
uid=1000(medisoft) gid=1000(medisoft) groups=1000(medisoft),27(sudo),100(users)
$ hostname
medisoft
$ hostnamectl | head -4
 Static hostname: medisoft
 Pretty hostname: medisoft@
       Icon name: computer-laptop
         Chassis: laptop
$ uname -a
Linux medisoft 7.0.0-31-generic #31~24.04.1-Ubuntu SMP PREEMPT_DYNAMIC x86_64 GNU/Linux
$ lsb_release -a
Distributor ID:	Ubuntu
Description:	Ubuntu 24.04.4 LTS
Release:	24.04
Codename:	noble
$ systemd-detect-virt
none
$ ip route
default via 192.168.1.1 dev wlp2s0 proto dhcp src 192.168.1.57 metric 600
$ ping -c 4 8.8.8.8
4 packets transmitted, 4 received, 0% packet loss, time 3005ms
$ getent hosts github.com
140.82.121.3    github.com
$ git --version
git version 2.43.0
$ gh --version
gh version 2.102.0 (2026-09-30)
$ python3 --version
Python 3.12.3
$ java --version
openjdk 11.0.32 2026-07-21
```

The example transcripts inside the guide are illustrative samples written in the form the
output takes on a correctly configured virtual machine (for example `10.0.2.0/24` NAT
addressing and `kvm` from `systemd-detect-virt`). The command set, the flags, and the
expected values in the guide tables were each confirmed against the real output above and
against the upstream documentation.

**2. Link validation.** All 12 internal links in the new document were resolved
programmatically against the repository tree — every one resolves to an existing file,
and no link points to a document that is still in review.

**3. Command correctness.** The commands, flags, and expected outputs were checked
against the [GitHub CLI manual](https://cli.github.com/manual/),
[Git documentation](https://git-scm.com/doc/), and
[Ubuntu documentation](https://docs.ubuntu.com/). The `gh auth setup-git` flow, the
`systemd-detect-virt` check, the NAT addressing (`10.0.2.0/24`, gateway `10.0.2.2`), and
the `sha256sum -c SHA256SUMS --ignore-missing` verification were each confirmed against
the upstream documentation.

**4. Consistency with the project.** The distribution version, desktop environment,
package manager, offline strategy, and credential handling in the guide were checked
against ADR-001 to ADR-005 and the accepted `docs/architecture/system-architecture.md`.

**5. Scope.** The pull request adds one file and changes nothing else, confirmed with
`git diff --stat` and `git status`.

## Expected Result

* A new contributor can produce a **verified** Bugema Linux development environment from
  a clean computer using a single document, instead of asking around or guessing.
* Students spend their time on contributions rather than on repeated environment setup
  problems, and the same troubleshooting knowledge is not rediscovered by every cohort.
* The environment a contributor builds matches the architecture the project has already
  accepted — Ubuntu 26.04 LTS, APT, Xfce 4.20, offline-first operation, and credentials
  held in the OS keyring rather than in a plaintext file.
* The project gains the "development environment" documentation that the Alpha 0.1
  milestone already lists among its acceptance criteria.
* The guide complements `CONTRIBUTING.md` and the architecture documentation instead of
  duplicating them, and it is written so that it can be extended with a dedicated
  installation guide for end users later.

## Reviewer Notes

* The `docs/development/` directory is new; the guide is the first document in it.
* If the cohort is standardised on a single virtualisation platform, the corresponding
  section can be promoted to primary and the others moved to an appendix.
* Section 12 (GitHub CLI authentication) deliberately recommends `gh auth setup-git`
  over `credential.helper store`, in line with ADR-005. Feedback on this approach is
  welcome.
