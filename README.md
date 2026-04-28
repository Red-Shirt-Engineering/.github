# XP Query Org-Level GitHub Templates

This folder contains the shared issue templates, PR template, and conventions doc that should live in the **org-level `.github` repository** for XP Quest.

## How GitHub resolves these

When a user opens an issue or PR in any repo in the org that does NOT have its own `.github/ISSUE_TEMPLATE/` directory, GitHub falls back to a repo literally named `.github` at the org level. That means these templates, once committed to `https://github.com/XP-Quest/.github`, automatically apply to `xpq-web`, `xpq-api`, and any future repos without per-repo duplication.

## Remote vs. local naming

The REMOTE repo must be named exactly `.github` — that's GitHub's trigger. The LOCAL clone directory can be anything; this project favors peer directories under `~/git/`, so clone it as `xpq-org`:

```bash
gh repo clone XP-Quest/.github ~/git/xpq-org
```

Inside `~/git/xpq-org/` you'll see a `.github/` subfolder — that's the actual template location, regardless of what the enclosing repo is called.

## To deploy

1. Create a new repo in the xpq org named exactly `.github` (public or internal — public is fine).
2. Copy the contents of this folder's `.github/` directory plus `SR_ED_CONVENTIONS.md` into the root of that repo.
3. Edit `.github/ISSUE_TEMPLATE/config.yml` and replace `REPLACE_WITH_ORG` with your actual org name.
4. Commit and push.
5. Test by opening a new issue in `xpquest` — the SR&ED Research and Engineering Task options should appear.

Or use `setup-org.sh` in this folder, which automates steps 1–4 plus seeds labels, creates the two Projects, and files placeholder research issues.

## Contents

```
.github/
├── ISSUE_TEMPLATE/
│   ├── sred-research.yml       SR&ED research issue (long-lived investigation)
│   ├── experiment-log.yml      Single experimental run under a parent research issue
│   ├── engineering-task.yml    Routine engineering, explicitly non-SR&ED
│   └── config.yml              Disables blank issues, links to conventions
└── pull_request_template.md    Default PR template with SR&ED linkage field

SR_ED_CONVENTIONS.md            The working conventions doc — how this all fits together
```

## What's NOT here yet

- Labels. GitHub doesn't let you define labels via template files — they need to be created per-repo via API or the UI. A `gh` script to seed labels is coming.
- Projects. Also not templatable — created via API.
- Per-repo overrides. If `xpq-web` or `xpq-api` need their own specific templates later, add a `.github/ISSUE_TEMPLATE/` folder in those repos and the org-level fallback won't apply.
