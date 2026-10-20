Peer review — #16 `Docs/student workflow guide`

Reviewed against the contribution criteria in `CONTRIBUTING.md`.

The contribution itself is a good one, and it is well targeted: a student workflow and
onboarding guide is exactly the documentation that the Open Source Systems course
needs, and the branch name `docs/student-workflow-guide` is short, descriptive, and
consistent with the naming conventions in `CONTRIBUTING.md` section 5. The single commit
message, `docs: add student git workflow and onboarding guide`, follows the convention
in section 6 and is clear about the intent of the change.

Two things need to be addressed.

**1. The file added by this pull request is empty (blocking).**

`docs/git-workflow-guide.md` is committed as a 0-byte file. The diff shows
`new file mode 100644` with `index 0000000..e69de29`, which is the empty blob, and
reading the file at the head of this pull request returns a size of 0. The guide is the
whole purpose of the pull request, so as it stands there is nothing to review.

This normally happens when the file is staged before the content is written:

```console
$ git add docs/git-workflow-guide.md    # staged while still empty
$ ... write the guide ...
$ git commit -m "docs: ..."              # the content was never re-added
```

Re-adding the file after writing it, and confirming with `git diff --cached --stat`,
should resolve it.

**2. The pull request description needs the standard sections.**

The description is currently the commit subject on its own, so a reviewer cannot see
what the guide covers, how it was tested, or what a reader gains from it. The project
and the course expect:

```text
## Summary
## Changes Made
## Testing
## Expected Result
```

For the guide, the "Testing" section could state that a student who had not contributed
before followed the guide from a clean clone and completed the issue → branch → commit →
push → pull request cycle using only the instructions in the guide, and that the
commands it lists were executed and their output recorded.

**One coordination note:** this pull request and #13 both add the same file,
`docs/git-workflow-guide.md`, from the same branch. It would help to keep one of them
as the canonical pull request once the content is pushed, and close the other, so that
reviewers are not comparing two versions of the same document.

The idea and the commit message are both good, so once the content of the guide is
committed and the description is filled in, this should be ready for maintainer review.
