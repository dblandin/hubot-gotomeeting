http = require('axios')

class GoToMeetingAdapter
  apiRoot: 'https://api.citrixonline.com/G2M/rest'
  joinRoot: 'https://www.gotomeeting.com/join'
  meetingsPath: '/meetings'
  token: process.env.HUBOT_GOTOMEETING_USER_TOKEN

  fetchAll: ->
    http.get(@apiRoot + @meetingsPath)

  fetch: (name) ->

  create: (params) ->

  joinUrl: (meetingId) ->
    @joinRoot + "/#{meetingId}"

module.exports = GoToMeetingAdapter
