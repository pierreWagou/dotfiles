---
description: Generate and post Pierre's daily standup using alan-skills:standup
---

Generate Pierre Romon's daily standup and optionally post it to Slack.

Delegate to `alan-skills:standup` with the following vault-first overrides:

## Vault overrides (apply before invoking alan-skills:standup)

1. **Read the vault first**: Check `📓 Journal/` for yesterday's notes, `🚀 Projects/` for active work, `📅 Meetings/` for any relevant meetings. Use this as additional context on top of what the skill fetches from Slack/Linear/GitHub.
2. **Voice**: match `🪞 Personal/Voice Profile.md` at `/Users/pierre.romon/Documents/Alan/🪞 Personal/Voice Profile.md`
3. **Identity**: Slack user U0B5H5GPS6T, GitHub pierreWagou, Linear "me", email pierre.romon@alan.eu
4. **No standup channel**: Pierre does not have a dedicated standup channel. Ask him where to post before sending, or just show the draft.

## Customize freely

The generic standup logic (fetching Slack activity, Linear issues, GitHub commits) stays in `alan-skills:standup`. The vault context and voice rules above are Pierre's personal layer.
