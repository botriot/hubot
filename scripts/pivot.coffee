# Description:
#   Pivot your company by fetching a new business plan from http://itsthisforthat.com/
#
# Commands:
#   hubot pivot - Generate a new idea
#
# Author:
#   botriot

module.exports = (robot) ->
  robot.respond /pivot/i, (msg) ->
    robot
      .http("http://itsthisforthat.com/api.php?json")
      .get() (err, res, body) ->
        body = JSON.parse body
        msg.send 'How about "the ' + body.this + ' for ' + body.that + '"?'
