---
description: Review and file notes for a specific meeting
---

Review and file notes for a meeting. Usage: `/meeting-review <meeting name or date>`

## Vault

Read `/Users/pierre.romon/Documents/Alan` for existing context on the meeting topic.

## Steps

1. **Find the meeting**: Search Quill for the meeting matching the provided name or date.
   - Use `search_meetings` with the title keywords or date range
   - If multiple matches, show the list and ask Pierre to confirm

2. **Fetch the transcript**: Always use `get_transcript` — never `get_minutes`.

3. **Read vault context**: Check `👥 People/` for notes on attendees. Check `🚀 Projects/` for related project context.

4. **Produce meeting notes**:
   - **Date, attendees, context**
   - **Key discussion points**: what was debated, what positions were taken
   - **Decisions made**: clear, actionable — tag `#decision`
   - **Action items**: who owns what, by when
   - **Context for follow-up**: anything Pierre should remember for the next meeting

5. **File**: Save as `📅 Meetings/YYYY-MM-DD -- <meeting title>.md`

6. **Update people notes**: For each attendee with notable context, update or create their note in `👥 People/<Name>.md`.

7. **Update project notes**: If the meeting relates to an active project, update `🚀 Projects/<Project Name>.md`.

## Voice

Match Pierre's voice from `🪞 Personal/Voice Profile.md` for any generated summaries.
