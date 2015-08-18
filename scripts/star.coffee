module.exports = (robot) ->
  robot.respond /star( me)?/i, (msg) ->
    msg
      .http("https://slack.com/api/search.all")
      .query(query: "has::star:", pretty: 1, token: process.env.SLACK_ACCESS_TOKEN, count: 5)
      .get() (err, res, body) ->
        result = JSON.parse(body)
        for star in result.messages.matches
          msg.send star.permalink
