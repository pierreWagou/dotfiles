---
description: Sweep Slack, Linear, Quill, Calendar, Gmail, and GitHub into the vault
---

Sweep all connected sources and file new information into the vault at /Users/pierre.romon/Documents/Alan.

## Vault-first retrieval

Before fetching anything, read the vault's `.vault-config.yml` to get `last_ingest` timestamps per source. Only fetch content created or updated after the last ingest date for each source. After filing everything, update `last_ingest` in `.vault-config.yml` with today's date.

## Identity

- Slack user: U0B5H5GPS6T (pierre.romon)
- Email: pierre.romon@alan.eu
- GitHub: pierreWagou
- Linear: "me"

## Sources

### Slack channels

Sweep each channel for threads where Pierre posted or was mentioned. Skip routine bot messages and automated notifications. File notable threads — decisions, discussions, announcements relevant to Pierre's work.

| Channel | ID | Focus |
|---|---|---|
| #announcements | C3TS255RQ | Company-wide |
| #team_hr_announcements | CS0MZ9YPM | HR |
| #product_announcements | C017M1KQ57U | Product |
| #office_announcements | C0276HRGX1R | Office |
| #engineering | C19FZEB41 | Engineering community |
| #tech-leadership | C0566L6Q77F | Tech leadership |
| #eng_org | CP0C60UC8 | Eng org |
| #org_alaner-sfa | C0LJ49SN5 | Weekly SFAs |
| #eng_announcements | CB55CK36Y | Eng announcements |
| #area_product_platform | C08VA4FTUAW | Area |
| #crew_outbound | C0A745QTFDJ | Outbound crew |
| #crew_payment_processing | C0948RBSLCE | Payment Processing crew |

For `#org_alaner-sfa`: archive Pierre's own SFAs as `📓 Journal/YYYY-MM-DD -- Weekly SFA.md`.

### Linear

1. Fetch issues assigned to Pierre (`list_issues`, assignee: "me"). Note status, priority, blockers.
2. Fetch active projects for Product Platform. Get latest status updates.
3. Create or update `🚀 Projects/<Project Name>.md` for each active project.

### Quill

Fetch Pierre's recent meetings (`search_meetings`, participants: pierre.romon@alan.eu). For each meeting:
- Always use `get_transcript` — never substitute `get_minutes`
- Prioritize: crew syncs, 1:1s, coaching sessions, incident debriefs
- File as `📅 Meetings/YYYY-MM-DD -- <title>.md`

### Google Calendar

Fetch upcoming events for the next 2 weeks. Map to Quill meeting notes where a transcript exists.

### Gmail

Search for threads where Pierre is a direct recipient or sender. Skip: automated notifications (Linear, GitHub, Ashby, calendar), marketing, newsletters.
- Focus on: decisions, action items, external conversations worth preserving
- File in relevant area folder or `🚀 Projects/`. Use frontmatter `source: gmail` and tag `#email`

### GitHub Discussions (alan-eu/Topics)

```bash
gh api graphql -f query='{ search(query: "author:pierreWagou repo:alan-eu/Topics", type: DISCUSSION, first: 20) { nodes { ... on Discussion { number title url createdAt } } } }'
gh api graphql -f query='{ search(query: "commenter:pierreWagou repo:alan-eu/Topics", type: DISCUSSION, first: 20) { nodes { ... on Discussion { number title url updatedAt } } } }'
```

For each discussion: create `💬 Discussions/<title>.md` with summary, Pierre's position, outcome, participants. Tag `#decision` if concluded.

Update `💬 Discussions/Watchlist.md` — all open discussions Pierre is involved in, with number, title, URL, category (pending/contributed/own), last activity, deadline if any.

### People

Create `👥 People/<Name>.md` for anyone appearing 3+ times across sources.

## Voice

Match Pierre's voice profile at `🪞 Personal/Voice Profile.md` for any generated text.

## Output

After filing everything, report:
- Notes created / updated per folder
- Any new projects found
- Upcoming meetings needing prep
