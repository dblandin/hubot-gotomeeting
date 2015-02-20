# hubot-gotomeeting

## Creating an unnamed one-time meeting

GoToMeeting requires every meeting to have a name, but sometimes you just don't
care. In this case, we'll create a name automatically based on the name of the
requester and the current time.

```
[devon] hubot: create meeting
[hubot] I've created a meeting 'devon-1424453821' for you:
[hubot] Organize: https://joingotomeeting.com/s234234.
[hubot] Join: https://joingotomeeting.com/s234234.
```

## Creating a one-time meeting with a name

This will create meeting with the specified name.

```
[devon] hubot: create meeting Impromptu Check-In
[hubot] I've created a meeting called 'Impromptu Check-In':
[hubot] Organize: https://joingotomeeting.com/s234234.
[hubot] Join: https://joingotomeeting.com/s234234.
```

## Creating a recurring meeting

This will a recurring meeting with the specified name. Recurring meetings won't
disappear from the meeting list after the first occurrence ends.

```
[devon] hubot: create recurring meeting Impromptu Check-In
[hubot] I've created a meeting called 'Impromptu Check-In':
[hubot] Organize: https://joingotomeeting.com/s234234.
[hubot] Join: https://joingotomeeting.com/s234234.
```

## Organize a meeting

This will retrieve the organizer link for the meeting.

```
[devon] hubot: organize meeting Impromptu Check-In
[hubot] Organize: https://joingotomeeting.com/s234234.
```

## Joining a meeting

This will retrieve the participant link for the meeting.

```
[devon] hubot: join meeting Impromptu Check-In
[hubot] Join: https://joingotomeeting.com/s234234.
```

## Listing known meetings

This will list all known meetings under the account. Flags are appended to
active and/or recurring meetings.

```
[devon] hubot: list meetings
[hubot] 'Impromptu Check-In' [active] [recurring]
[hubot] 'devon-1424453821'
```

## Installation

1. Add hubot-gotomeeting to your hubot setup: `npm install hubot-gotomeeting --save`
2. Add `hubot-gotomeeting` to your hubot's external-scripts.json
3. Set the required configuration options

## Configuration

`HUBOT_GOTOMEETING_USER_TOKEN: GoToMeeting User OAuth Token`

## Improvements

Improvements or requests are welcome. Please file an
[issue](https://github.com/dblandin/hubot-gotomeeting/issues) or pull request.
