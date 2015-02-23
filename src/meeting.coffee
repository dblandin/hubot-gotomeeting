Path               = require('path')
GoToMeetingAdapter = require(Path.join(__dirname, 'go_to_meeting_adapter'))

class Meeting
  constructor: (params) ->
    @params = params
    @adapter = new GoToMeetingAdapter

  start: ->
    @adapter.start(@id())

  id: ->
    @params.meetingid

  name: ->
    @params.subject

  status: ->
    @params.status

  meetingType: ->
    @params.meetingtype

  joinUrl: ->
    @adapter.joinUrl(@id())

  isActive: ->
    @status() is 'ACTIVE'

  isRecurring: ->
    @meetingType() is 'recurring'


module.exports = Meeting
