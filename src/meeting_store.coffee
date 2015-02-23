_                  = require('lodash')
Path               = require('path')
GoToMeetingAdapter = require(Path.join(__dirname, 'go_to_meeting_adapter'))

class MeetingStore
  constructor: (options) ->
    @adapter = new GoToMeetingAdapter

  create: (params) ->
    @adapter.create(_.defaults(params, @defaultMeetingParams()))

  find: (name, onFetch) ->
    @adapter.fetch(name)

  all: ->
    @adapter.fetchAll()

  _castToMeetings: (data) ->
    data.reduce (meetingParams) new Meeting(params)

  defaultMeetingParams: ->
    start: @now()
    end: @tomorrow()
    meetingType: 'Immediate'

  now: ->
    @_now ||= new Date()

  tomorrow: ->
    date = @now()
    date.setDate(date.getDate() + 1)
    date

module.exports = MeetingStore
