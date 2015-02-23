class MeetingListFormatter
  constructor: (meetings) ->
    @meetings = meetings

  message: ->
    messages = []
    messages.push(@formattedMeeting(meeting)) for meeting in @meetings
    messages.join("\n")

  formattedMeeting: (meeting) ->
    formatted = "#{meeting.name()}"
    formatted += ' [active]' if meeting.isActive()
    formatted += ' [recurring]' if meeting.isRecurring()
    formatted

module.exports = MeetingListFormatter
