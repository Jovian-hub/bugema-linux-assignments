Peer review — #17 `Clean up README ending and add contribution steps`

Reviewed against the contribution criteria in `CONTRIBUTING.md`.

This is a good cleanup, and it improves the most-read document in the repository. Moving
the "Contributing" section into the flow of the README, adding the step-by-step
contribution instructions, and moving the MIT licence note next to the licence reference
all make the README more useful for a first-time visitor, and the changes are purely
additive to the documentation — no code or configuration is touched. The branch name
`clean-up-readme` is short and descriptive.

A few specific points that would make the change complete.

**1. The relative link to the Issues tab will not resolve.**

```markdown
1. Check the [Issues](../../issues) tab for an open task, ...
```

In a Markdown file, `../../issues` is resolved relative to the path of the file, so on
GitHub it points outside the repository and renders as a broken link. The repository
root-relative form works from any file in the project:

```markdown
1. Check the [Issues](/issues) tab for an open task, or open a new issue to propose your idea.
```

**2. A sentence in the same section is now out of date.**

The section still reads:

> These documents will be added as the project governance framework is established.

but the list immediately above it now includes `CONTRIBUTING.md` and
`CODE_OF_CONDUCT.md`, both of which already exist in the repository. The sentence
contradicts the list, and a new contributor may wait for documents that are already
there. It would be better to remove it, or to replace it with something that describes
what the documents contain — for example, that they set out the contribution workflow
and the rules of engagement for the community.

**3. The file ends without a newline.**

The diff ends with `\ No newline at end of file`, which makes future diffs on the last
line of the file noisier than they need to be, and trips some markdown linters. Adding
a trailing newline resolves it:

```console
$ printf '\n' >> README.md
$ git add README.md
$ git commit -m "docs: add trailing newline to README"
```

**4. Consider linking the contribution steps instead of repeating them.**

The six steps in the new "How to contribute" subsection are a good summary, and they
are already documented in more detail in `CONTRIBUTING.md` sections 3, 5, 6, and 7.
Duplicated instructions drift apart over time, so it may be worth keeping the short
list in the README and adding a line such as:

```markdown
The full contribution workflow, including commit conventions, branch naming, and the
review process, is documented in [CONTRIBUTING.md](CONTRIBUTING.md).
```

That way the README stays readable while the authoritative version stays in one place.

**5. The pull request description is empty.**

The description is currently blank, so a reviewer has no summary of what changed or why.
The project convention is the four-section format:

```text
## Summary
## Changes Made
## Testing
## Expected Result
```

For a documentation change, a short "Testing" section is enough — for example, that
the README was rendered locally to confirm the headings, list, and link format, and
that the links to `CONTRIBUTING.md`, `CODE_OF_CONDUCT.md`, `GOVERNANCE.md`, and
`SECURITY.md` were confirmed to resolve.

**Summary**

| Item | Action |
| --- | --- |
| Link to the Issues tab | Change `../../issues` to `/issues` |
| Stale sentence | Remove or rewrite "These documents will be added..." |
| Trailing newline | Add one so the file ends with a newline |
| Duplication | Link to `CONTRIBUTING.md` for the authoritative workflow |
| PR description | Add the Summary / Changes Made / Testing / Expected Result sections |

These are all small, quick fixes. The substance of the change is good, and once the
link and the stale sentence are corrected the README will be noticeably clearer for new
contributors.
