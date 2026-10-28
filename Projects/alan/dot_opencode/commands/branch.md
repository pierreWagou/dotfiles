---
description: Create a git branch from a Linear ticket
---

Given a Linear ticket ID or URL in $ARGUMENTS:

## Step 1 — Parse ticket ID

Extract from $ARGUMENTS: bare ID (e.g. `PAY-1234`, `ARE-152`) or Linear URL.
If empty, ask the user for a ticket ID.

## Step 2 — Fetch ticket title

Use the Linear MCP `linear_get_issue` tool with the extracted ID.
If the ticket is not found, abort with a clear error.

## Step 3 — Build branch name

Slugify the ticket title:
1. Lowercase everything
2. Remove stop words: a, an, the, and, or, for, to, in, of, with, on, at
3. Replace non-alphanumeric characters with hyphens
4. Collapse multiple hyphens
5. Truncate to max 5 words (hyphen-separated segments)
6. Strip leading/trailing hyphens

Branch name: `pierreromon/<ticket-id-lowercase>/<slug>`

Examples:
- "Add PSP transaction endpoint" → `pierreromon/are-152/add-psp-transaction-endpoint`
- "Fix exemption yearly reminder email" → `pierreromon/aml-3141/fix-exemption-yearly-reminder`
- "Add favorite exercises modal to the app" → `pierreromon/play-5486/add-favorite-exercises-modal`

## Step 4 — Confirm

Show the user the proposed branch name and ask for confirmation before proceeding.

## Step 5 — Create branch

Run:

```bash
git branch <branch-name>
```

Report success or any error to the user.
