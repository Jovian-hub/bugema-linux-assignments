Hello maintainers and fellow students — this pull request is my Open Source Systems course
contribution, and it is ready for peer and maintainer review.

**What it does**

It adds `docs/development/development-environment-setup.md`, a guide for building and
verifying the Linux environment in which Bugema Linux development is done. It was
raised as issue #18 and this pull request closes it.

**Why this contribution**

`README.md` lists `docs/installation/` and `docs/development/` in the project structure,
but neither directory existed, and `CONTRIBUTING.md` explains how to *submit* a change
while assuming a working development environment is already in place. The guide fills
that gap and ties the setup steps to the decisions the project has already accepted
(ADR-001 to ADR-005), so that the environment a contributor builds matches the system
the project is designing.

**How it was tested**

Every command in the guide was executed on a live Linux system and the output compared
with the documented result, all 12 internal links were resolved programmatically against
the repository tree, and the command flags and expected outputs were checked against the
GitHub CLI, Git, and Ubuntu documentation. The full transcript is in the pull request
description.

**Review requested**

I would especially welcome feedback on:

1. whether the recommended virtual machine resources (2 vCPU, 4 GB RAM, 40 GB disk, NAT)
   match what the cohort will actually use — if the class is standardised on one
   virtualisation platform, I can promote that section and move the others to an
   appendix;
2. section 12, where I recommend `gh auth setup-git` instead of
   `credential.helper store`, so that GitHub credentials stay in the operating system
   keyring rather than in a plaintext `~/.git-credentials` file (ADR-005);
3. the troubleshooting table — the failures I have seen are the ones from my own setup,
   and colleagues will know of others that are missing.

The pull request adds one file and modifies nothing else, so it should not conflict with
the documentation work already in review. Please do not hesitate to leave comments on
any section — I will revise the guide and push the changes to this branch.
