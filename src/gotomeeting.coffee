# Description
#   GoToMeeting hubot script
#
# Configuration:
#   HUBOT_GOTOMEETING_USER_TOKEN : GoToMeeting User OAuth Token
#
# Commands:
#   hubot create meeting
#   hubot create meeting <name>
#   hubot create recurring meeting <name>
#   hubot host meeting <name>
#   hubot join meeting <name>
#   hubot list meetings
#
# Author:
#   Devon Blandin <dblandin@gmail.com>

Path         = require('path')
MeetingStore = require(Path.join(__dirname, 'meeting_store'))
_            = require('lodash')
apiRoot      = 'https://api.citrixonline.com/G2M/rest'
token        = process.env.HUBOT_GOTOMEETING_USER_TOKEN

formattedMeeting = (meeting) ->
  formatted = "#{meeting.subject}"
  formatted += ' [active]' if meeting.status is 'ACTIVE'
  formatted += ' [recurring]' if meeting.meetingType is 'recurring'
  formatted

printMeetings = (meetings) ->
  messages = ['Here are the meetings I know about:']
  messages.push(formattedMeeting(meeting)) for meeting in meetings
  messages.join("\n")

printJoinUrl = (meeting) ->
  "Join meeting '#{meeting.subject}' at https://www.gotomeeting.com/join/#{meeting.meetingid}"

ensureConfig = (msg) ->
  if process.env.HUBOT_GOTOMEETING_USER_TOKEN?
    true
  else
    msg.reply 'HUBOT_GOTOMEETING_USER_TOKEN is not set.'

    false

findMeeting = (meetings, name) ->
  _.find(meetings, (meeting) -> meeting.subject is name)

module.exports = (robot) ->
  robot.respond /host meeting (.*)/i, (msg) ->
    return unless ensureConfig(msg)

    name  = msg.match[1].trim()
    store = new MeetingStore()

    store.all()
      .then (response) ->
        if meeting = findMeeting(response.data, name)
          msg.http(apiRoot + "/meetings/#{meeting.meetingid}/start")
            .headers(Authorization: "OAuth oauth_token=#{token}", Accept: 'application/json')
            .get() (err, res, body) ->
              switch res.statusCode
                when 200
                  hostURL = JSON.parse(body).hostURL

                  msg.reply("Host meeting '#{name}' at #{hostURL}")
                when 403
                  msg.reply 'Token has expired. Please generate and set a new one.'
                else
                  msg.reply "Unable to process your request and we're not sure why :("
  robot.respond /join meeting (.*)/i, (msg) ->
    return unless ensureConfig(msg)

    name  = msg.match[1].trim()
    store = new MeetingStore()

    store.all()
      .then (response) ->
        if meeting = findMeeting(response.data, name)
          msg.reply(printJoinUrl(meeting))
        else
          msg.reply("Sorry, I can't find that meeting")

  robot.respond /create meeting/i, (msg) ->
    return unless ensureConfig(msg)

    user     = msg.message.user
    now      = new Date
    tomorrow = new Date(now)
    tomorrow.setDate(now.getDate() + 1)

    subject = "#{user.name}-#{now.getTime()}"
    data = JSON.stringify({
      subject: subject,
      starttime: now.toISOString(),
      endtime: tomorrow.toISOString(),
      passwordrequired: false,
      conferencecallinfo: 'Hybrid',
      timezonekey: '',
      meetingtype: 'Immediate'
    })

    msg.http(apiRoot + '/meetings')
      .headers(Authorization: "OAuth oauth_token=#{token}", Accept: 'application/json')
      .post() (err, res, body) ->
        switch res.statusCode
          when 201
            meeting = JSON.parse(body)[0]
            msg.reply "I've created a meeting for you: #{meeting.joinURL}"
          when 403
            msg.reply 'Token has expired. Please generate and set a new one.'
          else
            msg.reply "Unable to process your request and we're not sure why :("

  robot.respond /list meetings/i, (msg) ->
    return unless ensureConfig(msg)

    store = new MeetingStore()

    store.all()
      .then((response) -> msg.reply printMeetings(response.data))
