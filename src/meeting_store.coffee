Path = require('path')
GoToMeetingAdapter = require(Path.join(__dirname, 'go_to_meeting_adapter'))

class Meeting
  constructor: (params) ->
    @params = params

  name: ->
    @params.subject

class MeetingStore
  constructor: (options) ->
    @adapter = new GoToMeetingAdapter

  create: (params, onCreate) ->
    @adapter.create(params)
      .then(onCreate)

  find: (name, onFetch) ->
    @adapter.fetch(name)

  all: (onFetch) ->
    @adapter.fetchAll()

  _castToMeetings: (data) ->
    data.reduce (meetingParams) new Meeting(params)

module.exports = MeetingStore
