http = require('axios')

class GoToMeetingAdapter
  apiRoot: 'https://api.citrixonline.com/G2M/rest'
  meetingsPath: '/meetings'
  token: process.env.HUBOT_GOTOMEETING_USER_TOKEN

  fetchAll: ->
    http.get(@apiRoot + @meetingsPath)

  fetch: (name) ->

  create: (params) ->

module.exports = GoToMeetingAdapter
