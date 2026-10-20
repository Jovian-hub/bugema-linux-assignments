Peer review — #13 `docs: add Git workflow and onboarding guide (closes #12)`

Reviewed against the contribution criteria in `CONTRIBUTING.md` and the project
contribution workflow. The idea behind this PR is a good one: the course workflow in
`README.md` and `CONTRIBUTING.md` describes the *process*, but a guide that walks a new
student through it step by step is exactly what the project needs, and a student
onboarding guide directly supports the Open Source Systems course. The branch name
`docs/git-workflow-guide` is short, descriptive, and follows the naming conventions in
`CONTRIBUTING.md` section 5.

There are a few points to address before this can be merged.

**1. The two files added by this PR are empty (blocking).**

`docs/git-workflow-guide.md` and `.github/workflows/shellcheck.yml` are both committed as
0-byte files — the diff shows `new file mode 100644` with `index 0000000..e69de29`, which
is the empty blob. The guide and the workflow are therefore not actually part of the
change, so there is nothing to review, and the guide is the entire purpose of the PR.

This usually happens when the file is staged before the content is written:

```console
$ git add docs/git-workflow-guide.md     # staged while still empty
$ ... write the content ...
$ git commit -m "docs: ..."               # content never re-added
```

Re-adding the file after writing it (`git add docs/git-workflow-guide.md` again, then
`git diff --cached --stat` to confirm the line count) should resolve it.

**2. The commit history contains a vague message and a self-cancelling pair.**

```text
3b2966a  j
c4b0a71  Enhance Code of Conduct with communication guidelines
7e815e2  Delete respectful communication guidelines
2037497  docs: add student git workflow and onboarding guide
```

* `j` carries no information for anyone reading `git log`. `CONTRIBUTING.md` section 6
  asks for meaningful messages such as `docs: add student git workflow and onboarding
  guide`, which the fourth commit already uses.
* "Enhance Code of Conduct with communication guidelines" is immediately undone by
  "Delete respectful communication guidelines", and the net effect on
  `CODE_OF_CONDUCT.md` is the removal of a single `---` separator. The two messages
  describe changes that are not present in the final diff, which will mislead anyone
  reviewing the history later.

Squashing the branch into one focused commit with a descriptive message would keep the
history readable, for example:

```console
$ git rebase -i upstream/main
$ git commit --amend -m "docs: add student git workflow and onboarding guide"
```

**3. The scope of the PR is wider than its title.**

`CONTRIBUTING.md` section 7 asks pull requests to avoid unrelated changes. As it
stands, this PR carries three separate concerns: the onboarding guide, a ShellCheck CI
workflow, and a whitespace edit to `CODE_OF_CONDUCT.md`. Splitting the CI workflow into
its own pull request (for example `ci/add-shellcheck-workflow`, with the issue reference
it already carries) would let each change be reviewed on its own merits.

**4. The ShellCheck workflow has nothing to check yet.**

The repository currently contains no shell scripts — `git ls-files '*.sh'` returns
nothing — so a ShellCheck workflow would either do nothing or fail on the first run
depending on how the `on:` and `paths:` filters are written. If the workflow is kept,
it would be worth adding the `paths:` filter for the `scripts/` directory that the
project structure in `README.md` already reserves, and testing the workflow once
(`actionlint .github/workflows/shellcheck.yml`, or by pushing a branch and reading the
Actions tab) so the failure mode is known in advance. `CONTRIBUTING.md` section 9
explicitly lists CI testing as part of the expected testing evidence.

**5. The pull request description needs the standard sections.**

The description is currently a single line, so a reviewer cannot tell what the guide
covers, how it was tested, or what a reader gains from it. The project and the course
expect the following structure:

```text
## Summary
## Changes Made
## Testing
## Expected Result
```

For the guide, the "Testing" section could state that a contributor who has never
contributed before followed the guide from a clean clone and reached a working state —
for example, that the branch, commit, and pull request steps in the guide were followed
verbatim on a test repository, and that the commands in the guide were executed and
their output recorded.

**6. Please close one of the two open pull requests.**

This pull request and #16 both come from the branch `docs/git-workflow-guide` and both
add `docs/git-workflow-guide.md`, so the same file is being proposed twice. Once the
content is pushed, it would be good to keep one pull request as the canonical one and
close the other, so reviewers do not have to compare two versions of the same guide.

**Summary of what is needed**

| Item | Action |
| --- | --- |
| `docs/git-workflow-guide.md` | Push the actual content of the guide |
| Commit history | Remove the `j` commit and squash the self-cancelling pair into one descriptive commit |
| Scope | Move the ShellCheck workflow and the `CODE_OF_CONDUCT.md` whitespace change into separate pull requests |
| CI workflow | Confirm it has a `paths:` filter for the `scripts/` directory and test it once |
| PR description | Add the Summary / Changes Made / Testing / Expected Result sections |
| Duplicate PR | Close #16 (or #13) once the content is pushed |

With the file content in place, the rest of the changes are small and mechanical. The
guide itself is a welcome addition to the project — the only significant work left is
getting the content committed and the pull request description finished.
