http = require('axios')

class GoToMeetingAdapter
  apiRoot: 'https://api.citrixonline.com/G2M/rest'
  joinRoot: 'https://www.gotomeeting.com/join'
  meetingsPath: '/meetings'
  token: process.env.HUBOT_GOTOMEETING_USER_TOKEN

  fetchAll: ->
    http.get(@apiRoot + @meetingsPath, headers: @_headers())

  fetch: (name) ->

  create: (params) ->
    http.post(@apiRoot + @meetingsPath, @_meetingParams(params), headers: @_headers())

  start: (meetingId) ->
    http.get(@apiRoot + @meetingsPath + "/#{meetingId}/start", headers: @_headers())

  joinUrl: (meetingId) ->
    @joinRoot + "/#{meetingId}"

  _headers: ->
    'Authorization': "OAuth oauth_token=#{@token}"
    'Accept': 'application/json'
    'Content-Type': 'application/json'

  _meetingParams: (params) ->
    subject: params.name
    starttime: params.start.toISOString()
    endtime: params.end.toISOString()
    passwordrequired: false
    conferencecallinfo: 'Hybrid'
    timezonekey: ''
    meetingtype: params.meetingType

module.exports = GoToMeetingAdapter
