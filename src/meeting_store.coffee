_                  = require('lodash')
Path               = require('path')
GoToMeetingAdapter = require(Path.join(__dirname, 'go_to_meeting_adapter'))

class Meeting
  constructor: (params) ->
    @params = params

  name: ->
    @params.subject

class MeetingStore
  constructor: (options) ->
    @adapter = new GoToMeetingAdapter

  create: (name) ->
    @adapter.create(_.defaults({ subject: name }, @defaultMeetingParams()))

  find: (name, onFetch) ->
    @adapter.fetch(name)

  all: ->
    @adapter.fetchAll()

  _castToMeetings: (data) ->
    data.reduce (meetingParams) new Meeting(params)

  defaultMeetingParams: ->
      starttime: @now().toISOString()
      endtime: @tomorrow().toISOString()
      passwordrequired: false
      conferencecallinfo: 'Hybrid'
      timezonekey: ''
      meetingtype: 'Immediate'

  now: ->
    @_now ||= new Date()

  tomorrow: ->
    date = @now()
    date.setDate(date.getDate() + 1)
    date

module.exports = MeetingStore
