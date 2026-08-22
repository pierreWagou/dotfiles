---
description: Generate and post Pierre's daily standup using alan-skills:standup
---

Generate Pierre Romon's daily standup and optionally post it to Slack.

Delegate to `alan-skills:standup` with the following vault-first overrides:

## Vault overrides (apply before invoking alan-skills:standup)

1. **Read the vault first**: Check `📓 Journal/` for yesterday's notes, `🚀 Projects/` for active work, `📅 Meetings/` for any relevant meetings. Use this as additional context on top of what the skill fetches from Slack/Linear/GitHub.
2. **Voice**: match `🪞 Personal/Voice Profile.md` at `/Users/pierre.romon/Documents/Alan/🪞 Personal/Voice Profile.md`
3. **Identity**: Slack user U0B5H5GPS6T, GitHub pierreWagou, Linear "me", email pierre.romon@alan.eu
4. **Posting**: Draft-post to `#crew_outbound` (channel ID: `C0A745QTFDJ`). Each day gets its own thread — create a new thread with today's date as the topic. Use `slack_send_message_draft` so Pierre can review before sending.

## Template (follow exactly)

The standup output MUST match this template exactly — no extra sections, no reordering, no alternative formatting:

```
:alan-hug: How do you feel today?

:done: What did you complete?
:progress: What are you doing?
:todo: What's on your todo list?

:interrobang: Any blockers or questions you want to share? (omit if none)
```

### Template rules

**IMPORTANT**: Focus on actual work done. Do NOT include meetings, syncs, or calendar items in ANY section.

- `:alan-hug:` — light, personal opener. **Ask Pierre via the `question` tool how he's feeling today and use his exact answer.** Never invent this yourself.
- `:done:` — list accomplishments from the day (merged PRs, completed Linear issues, key decisions, work outcomes). Each item on its own line, with inline links.
- `:progress:` — list in-progress work (open PRs, active Linear issues, ongoing discussions). Each item on its own line, with inline links.
- `:todo:` — list planned work for today (issues to pick up, things to build, problems to solve). Each item on its own line.
- `:interrobang:` — blockers, questions, or things needing input. **Ask Pierre via the `question` tool if he has any blockers or questions. If he has none, omit this section entirely.**
- Use standard markdown links `[text](URL)` throughout.
- Blank line between every section for Slack line breaks.
- Do NOT add or reorder sections.

### Inference rules

**CRITICAL**: You MUST actively infer content from gathered data. Placeholders are a LAST RESORT.

Before using a placeholder for any section, verify:
1. You have searched ALL data sources (Slack, Linear, GitHub, Calendar, Docs, Quill, Notion, Incidents)
2. You have tried to infer from context (e.g., meetings today → todo items)
3. You have found ZERO relevant items for that section

- `:done:` — Combine GitHub (merged PRs, commits), Linear (completed/progressed issues), Notion (pages created), Google Docs (documents created/modified), Quill (work decisions/outcomes), and key Slack discussions. Each item must link to its source. Only use a placeholder if ALL sources returned nothing. Exclude meetings and syncs.
- `:progress:` — Infer from in-progress Linear issues, open PRs, active Slack threads. Only use a placeholder if there is genuinely no ongoing work. Exclude meetings and syncs.
- `:todo:` — Infer from in-progress issues that need attention, open PRs awaiting action, problems to solve. Only use a placeholder if there is genuinely no work to do. Exclude meetings and syncs.
- `:interrobang:` — Only present if Pierre reports blockers or questions via the `question` tool. If he has none, omit this section entirely.

### Example output

```
:alan-hug: Feeling good

:done: merged [PR #1234](https://github.com/alan-eu/alan-apps/pull/1234) for events pipeline consumer
:done: progressed [TF-567](https://linear.app/alan/issue/TF-567) events archiver to code review
:done: discussed Tsuga pricing in [#area_tech_foundations](https://alan-eu.slack.com/archives/C123/p456)

:progress: reviewing [PR #1235](https://github.com/alan-eu/alan-apps/pull/1235) for events pipeline
:progress: drafting architecture doc for events v2

:todo: pick up [TF-580](https://linear.app/alan/issue/TF-580) events retry logic
:todo: prepare architecture doc for events v2
:todo: follow up on [TF-570](https://linear.app/alan/issue/TF-570) blocker
```

### Validation checklist

Before outputting, verify:
- [ ] No placeholder text unless ALL data sources were exhausted
- [ ] No meetings or syncs in ANY section
- [ ] Each `:done:` and `:progress:` item has an inline link
- [ ] `:todo:` items are specific and actionable
- [ ] Blank line between every section
- [ ] No extra sections added, no sections removed or reordered
- [ ] Exactly 4 or 5 sections present: `:alan-hug:`, `:done:`, `:progress:`, `:todo:`, and optionally `:interrobang:`

## Posting workflow

1. Gather activity data via the skill
2. **Ask Pierre via the `question` tool** how he's feeling today (for the `:alan-hug:` section) — use his exact answer, never invent one
3. **Ask Pierre via the `question` tool** if he has any blockers or questions (for the `:interrobang:` section)
4. If he has blockers/questions, include `:interrobang:`; otherwise omit it
5. Generate the standup message using the template above
6. Create a new thread in `#crew_outbound` (channel ID: `C0A745QTFDJ`) with today's date as the topic
7. Post the standup as a draft in that thread using `slack_send_message_draft`
8. Pierre reviews and sends
