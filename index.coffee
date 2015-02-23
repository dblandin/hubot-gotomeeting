Path = require 'path'

module.exports = (robot) ->
  robot.loadFile(Path.resolve(__dirname, "src"), 'gotomeeting.coffee')
