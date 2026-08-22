---
name: schedule-meeting
description: "Schedule a meeting, Google Meet, 1:1, coffee chat, or sync call with someone. Use when the user wants to set up a meeting with another person on a date range. Requires Google Calendar MCP (via hopper) and Slack MCP."
---

# Schedule Meeting

Interactive meeting scheduler that checks availability across calendars and creates Google Meet events.

## Workflow

### 1. Parse user request

Extract from the user's message:
- **Attendee**: name or email
- **Date range**: specific dates or relative (next week, tomorrow, etc.)
- **Duration**: if specified, otherwise infer from context
- **Title/context**: if specified, otherwise infer

If the date range is ambiguous, ask the user to clarify.

### 2. Resolve attendee email

Use Slack MCP to find the attendee's email:
- Call `slack_read_user_profile` with the attendee's name or Slack handle
- If no match, try `slack_search_users` with the name
- If still no match, ask the user for the email address

Store the resolved email as `ATTENDEE_EMAIL`.

### 3. Infer meeting type and duration

Use context clues to determine the meeting type and default duration:

| Context | Duration | Title pattern |
|---|---|---|
| "1:1", "one-on-one" with direct report | 30min | "1:1 with {name}" |
| "coffee", "chat", "get to know" | 25min | "Coffee with {name}" |
| "sync", "catch up" | 30min | "Sync with {name}" |
| "intro", "introduction" | 30min | "Intro with {name}" |
| "interview", "call" | 45min | "Call with {name}" |
| Technical deep-dive | 60min | "{topic} with {name}" |
| No context clues | Ask user | Ask user |

Check the vault `👥 People/` note for this person (if it exists) to infer context from past meetings.

### 4. Check availability

Call `calendar_suggest_time` with:
- `time_min`: RFC3339 start of search window (first day of range, 09:00 Europe/Paris)
- `time_max`: RFC3339 end of search window (last day of range, 18:00 Europe/Paris)
- `attendee_emails`: `[USER_EMAIL, ATTENDEE_EMAIL]`
- `time_zone`: `"Europe/Paris"`

This returns raw busy intervals for both calendars.

### 5. Compute free slots

Parse the busy intervals and find available slots:

```
For each working day in the range:
  1. Start with work window: 09:00 - 18:00
  2. Subtract busy intervals for both user and attendee
  3. Find gaps >= duration
  4. Split gaps at lunch (12:00 - 13:00) — no slots during lunch
  5. Round to nearest 15-minute boundary
  6. Keep slots that fit the duration
```

Sort by proximity to "now" (soonest available first).

### 6. Present options

Show 5-10 best slots as interactive choices. Format:

```
Here are the available slots for a {duration} meeting with {attendee}:

1. Monday, July 7 at 10:00 - 10:30
2. Monday, July 7 at 14:00 - 14:30
3. Tuesday, July 8 at 09:30 - 10:00
4. Tuesday, July 8 at 11:00 - 11:30
5. Wednesday, July 9 at 10:00 - 10:30

Which slot works best? (pick a number or suggest a different time)
```

Use the `question` tool with options for interactive selection.

### 7. Create event

Once the user selects a slot, call `calendar_create_event` with:
- `summary`: the inferred or specified title
- `start`: `{"dateTime": "RFC3339", "timeZone": "Europe/Paris"}`
- `end`: `{"dateTime": "RFC3339", "timeZone": "Europe/Paris"}`
- `attendees`: `[{"email": ATTENDEE_EMAIL}]`
- `conference_data`: `{"createRequest": {"requestId": "<unique-uuid>", "conferenceSolutionKey": {"type": "hangoutsMeet"}}}`
- `send_updates`: `"all"`

After creation, confirm with the user:
- Meeting title
- Date and time
- Google Meet link (from `hangoutLink` or `conferenceData.entryPoints[0].uri`)
- Calendar event ID (for reference)

## MCP Tools Required

| Tool | Purpose |
|---|---|
| `slack_read_user_profile` | Resolve attendee name → email |
| `mcp__google-calendar__calendar_suggest_time` | Check free/busy across calendars |
| `mcp__google-calendar__calendar_create_event` | Create event with Google Meet |

## Edge cases

- **Attendee not found on Slack**: Ask user for email directly
- **No free slots in range**: Suggest extending the range or shortening the duration
- **One attendee has no calendar**: Proceed with just the user's availability, note the gap
- **Past date range**: Reject and ask for a future date range
- **Weekend in range**: Skip weekends (Saturday, Sunday)
- **Holiday in range**: Could check but for now just show slots — user can reject

## Timezone handling

All times are in Europe/Paris. When converting RFC3339 timestamps from the API, always interpret them in Europe/Paris for display. The `time_zone` parameter in `calendar_suggest_time` ensures busy intervals are returned in the correct timezone.

## Working hours

Hardcoded to 09:00 - 18:00 Europe/Paris, Monday - Friday. No slots outside these hours. Lunch break (12:00 - 13:00) is excluded.
