expect = require('chai').expect
path   = require('path')
nock   = require('nock')

Robot       = require('hubot/src/robot')
TextMessage = require('hubot/src/message').TextMessage

describe 'hubot-gotomeeting', () ->
  robot   = null
  user    = null
  adapter = null

  beforeEach (done) ->
    nock('https://api.citrixonline.com/G2M/rest')
      .get('/meetings').replyWithFile(200, __dirname + '/fixtures/meetings.json')
      .post('/meetings').replyWithFile(201, __dirname + '/fixtures/create_meeting.json')

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

  it 'can will let you know when a meeting cannot be found', (done) ->
    adapter.on 'reply', (envelope, strings) ->
      expect(strings[0]).match(/Sorry, I can't find that meeting/)

      done()

    adapter.receive(new TextMessage(user, 'hubot join meeting Unknown Meeting'))

  it 'can fetch the join URL for a meeting', (done) ->
    adapter.on 'reply', (envelope, strings) ->
      expect(strings[0]).match(/Join Weekly Product Meeting at /)

      done()

    adapter.receive(new TextMessage(user, 'hubot join meeting Weekly Product Meeting'))

  it 'lists known meetings', (done) ->
    adapter.on 'reply', (envelope, strings) ->
      expect(strings[0]).match(/meetings/)
      expect(strings[0]).match(/Weekly Product Meeting/)

      done()

    adapter.receive(new TextMessage(user, 'hubot list meetings'))

  it 'can create a meeting for you', (done) ->
    adapter.on 'reply', (envelope, strings) ->
      expect(strings[0]).match(/I've created a meeting for you:/)

      done()

    adapter.receive(new TextMessage(user, 'hubot create meeting'))
