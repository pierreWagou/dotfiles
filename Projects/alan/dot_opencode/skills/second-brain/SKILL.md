---
name: second-brain
description: Pierre Romon's personal second brain at /Users/pierre.romon/Documents/Alan. Load and query this vault proactively whenever the user is doing any Alan work — drafting messages, preparing for meetings, discussing people or projects, writing SFAs, reviewing Linear issues, or asking about context. The vault contains People notes, Projects, Meetings, Discussions, Growth data, and a Voice Profile. Use it to enrich every response with accumulated personal context before acting.
---

# Second Brain

Pierre Romon's personal knowledge vault is at `/Users/pierre.romon/Documents/Alan`.

## When to use the vault (broad — default ON for Alan work)

Use the vault proactively whenever Pierre is doing any of the following:

- **Drafting a Slack message** → read `👥 People/<recipient>.md` + `🚀 Projects/` for context, read `🪞 Personal/Voice Profile.md` for tone
- **Preparing for a meeting** → read `👥 People/<attendees>.md` + `📅 Meetings/` for past meeting notes + `🚀 Projects/` for related work
- **Discussing a person** → read `👥 People/<name>.md` before responding
- **Discussing a project or task** → read `🚀 Projects/<project>.md` for current status and history
- **Writing an SFA or standup** → read `📓 Journal/` for recent SFAs + `🚀 Projects/` for active work
- **Answering "what do I know about X?"** → search across all folders for X
- **Reviewing a Linear issue or PR** → check `🚀 Projects/` for the parent project context
- **After a meeting** → update or create `📅 Meetings/YYYY-MM-DD -- <title>.md` and relevant `👥 People/` notes
- **Discussing a GitHub Discussion** → read `💬 Discussions/` for existing notes and `💬 Discussions/Watchlist.md`
- **Any growth or feedback conversation** → read `🌱 Growth/` for coaching notes, continuous feedback, praises

## Vault anatomy — what lives where

| Folder | Contents | When to read |
|---|---|---|
| `🚀 Projects/` | Active workstreams, woodchucks, onboarding, Linear projects | Before any project discussion or Linear sync |
| `🪞 Personal/` | Voice Profile — tone, style, drafting rules | Before drafting any message or document |
| `👑 Leadership/` | Strategy, level definitions, area context | When discussing career, levels, or area strategy |
| `🌱 Growth/` | Continuous feedback, praises, coaching notes, reviews | Before 1:1s, self-reviews, or impact reviews |
| `👥 People/` | One note per person — relationship, interactions, context | Before any message to or meeting with that person |
| `📅 Meetings/` | Meeting notes with decisions and action items | Before follow-up on a past meeting |
| `💬 Discussions/` | GitHub Discussions watchlist + per-discussion notes | When a GitHub Discussion comes up |
| `📓 Journal/` | Daily notes, weekly SFAs, weekly reviews | When writing SFAs, standups, or weekly reviews |
| `🗂️ Assets/` | Images | Rarely needed directly |

## How to query the vault

1. **By person**: read `👥 People/<Name>.md` — if it doesn't exist, Pierre hasn't interacted with them enough yet
2. **By project**: read `🚀 Projects/<Project Name>.md`
3. **By date**: meetings and journal entries use `YYYY-MM-DD -- <title>.md` naming
4. **By tag**: frontmatter tags like `#decision`, `#onboarding`, `#crew` can be grepped across the vault
5. **Broad search**: use Glob or Grep across `/Users/pierre.romon/Documents/Alan` for any keyword

## Voice profile

Before generating any text on Pierre's behalf, read `🪞 Personal/Voice Profile.md`. Key rules:
- Warm and direct — greeting + wave for new contacts or channels
- Short to medium length, get to the point fast
- Light emoji usage (`:wave:`, `:pray:`, `:smile:`) as social lubricant, not decoration
- Technical positions stated clearly, then softened with context acknowledgement
- Never acronyms — spell things out
- Always include relevant links

## Slash commands available

| Command | When to suggest |
|---|---|
| `/ingest` | "I haven't run ingest today", start of day, before weekly review |
| `/weekly-review` | Tuesday evening or Wednesday morning |
| `/meeting-review <name>` | After any significant meeting |
| `/draft-message <ask>` | Any Slack drafting request |
| `/standup` | Daily standup time |
| `/write-sfa` | Monday or Tuesday — end of Alan week |

## When NOT to use the vault

- Pure technical questions unrelated to Alan context (e.g. "how does PostgreSQL index work?")
- Code reviews with no personal or project context needed
- Generic programming help

## Vault config

`.vault-config.yml` at vault root tracks `last_ingest` per source. Check it to know how fresh the vault data is. If last ingest was more than 2 days ago, suggest running `/ingest` before proceeding.
