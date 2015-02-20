expect = require('chai').expect
path   = require('path')

Robot       = require('hubot/src/robot')
TextMessage = require('hubot/src/message').TextMessage

describe 'something', () ->
  robot   = null
  user    = null
  adapter = null

  beforeEach (done) ->
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

  it "does something", (done) ->
    adapter.on 'reply', (envelope, strings) ->
      expect(strings[0]).match(/how high/)

      done()

    adapter.receive(new TextMessage(user, 'hubot jump'))
