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
#   hubot organize meeting <name>
#   hubot join meeting <name>
#   hubot list meetings
#
# Author:
#   Devon Blandin <dblandin@gmail.com>

formattedMeeting = (meeting) ->
  formatted = "#{meeting.subject}"
  formatted += ' [active]' if meeting.status is 'ACTIVE'
  formatted += ' [recurring]' if meeting.meetingType is 'recurring'
  formatted

printMeetings = (meetings) ->
  messages = ['Here are the meetings I know about:']
  messages.push(formattedMeeting(meeting)) for meeting in meetings
  messages.join("\n")

ensureConfig = (msg) ->
  if process.env.HUBOT_GOTOMEETING_USER_TOKEN?
    true
  else
    msg.reply 'HUBOT_GOTOMEETING_USER_TOKEN is not set.'

    false

module.exports = (robot) ->
  robot.respond /create meeting/i, (msg) ->
    return unless ensureConfig(msg)

    user     = msg.message.user
    now      = new Date
    tomorrow = new Date(now)
    tomorrow.setDate(now.getDate() + 1)

    subject = "#{user.name}-#{now.getTime()}"
    token = process.env.HUBOT_GOTOMEETING_USER_TOKEN
    data = JSON.stringify({
      subject: subject,
      starttime: now.toISOString(),
      endtime: tomorrow.toISOString(),
      passwordrequired: false,
      conferencecallinfo: 'Hybrid',
      timezonekey: '',
      meetingtype: 'Immediate'
    })

    msg.http('https://api.citrixonline.com/G2M/rest/meetings')
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

    token = process.env.HUBOT_GOTOMEETING_USER_TOKEN
    msg.http('https://api.citrixonline.com/G2M/rest/meetings')
      .headers(Authorization: "OAuth oauth_token=#{token}", Accept: 'application/json')
      .get() (err, res, body) ->
        switch res.statusCode
          when 200
            msg.reply printMeetings(JSON.parse(body))
          when 403
            msg.reply 'Token has expired. Please generate and set a new one.'
          else
            msg.reply "Unable to process your request and we're not sure why :("
