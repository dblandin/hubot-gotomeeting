expect = require('chai').expect
path   = require('path')
nock   = require('nock')

nock('https://api.citrixonline.com/G2M/rest')
  .get('/meetings')
  .reply(200, [{
    "startTime":          "2015-02-17T00:10:33.+0000",
    "createTime":         "",
    "meetingid":          525164341,
    "maxParticipants":    26,
    "passwordRequired":   "false",
    "status":             "INACTIVE",
    "subject":            "Weekly Product Meeting",
    "meetingType":        "recurring",
    "endTime":            "2015-02-17T01:10:33.+0000",
    "uniqueMeetingId":    525164341,
    "conferenceCallInfo": "US: +1 (571) 317-3131\nAccess Code: 525-164-341"
  }])

Robot       = require('hubot/src/robot')
TextMessage = require('hubot/src/message').TextMessage

describe 'something', () ->
  robot   = null
  user    = null
  adapter = null

  beforeEach (done) ->
    process.env.HUBOT_GOTOMEETING_USER_TOKEN = 'abc123'
    robot = new Robot(null, 'mock-adapter', false, 'hubot')

    robot.adapter.on 'connected', ->
      require('../src/gotomeeting.coffee')(robot)

      user = robot.brain.userForId('1', {
        name: "mocha",
        room: "#mocha"
      })

      adapter = robot.adapter

      done()

    robot.run()

  afterEach ->
    robot.shutdown()

  it 'alerts you when the required environment variable is not set', (done) ->
    delete process.env.HUBOT_GOTOMEETING_USER_TOKEN

    adapter.on 'reply', (envelope, strings) ->
      expect(strings[0]).match(/HUBOT_GOTOMEETING_USER_TOKEN is not set/)

      done()

    adapter.receive(new TextMessage(user, 'hubot list meetings'))

  it 'lists known meetings', (done) ->
    adapter.on 'reply', (envelope, strings) ->
      expect(strings[0]).match(/meetings/)

      done()

    adapter.receive(new TextMessage(user, 'hubot list meetings'))
