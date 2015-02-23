Path               = require('path')
GoToMeetingAdapter = require(Path.join(__dirname, 'go_to_meeting_adapter'))

class Meeting
  constructor: (params) ->
    @params = params
    @adapter = new GoToMeetingAdapter

  name: ->
    @params.subject

  start: ->
    @adapter.start(@id())

  id: ->
    @params.meetingid

  joinUrl: ->
    @adapter.joinUrl(@id())

module.exports = Meeting
