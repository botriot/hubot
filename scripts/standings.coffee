# standings-table

cheerio = require "cheerio"
_ = require "underscore"

module.exports = (robot) ->

  serializeRow = (tr) ->
    {
      rank: tr.find(".rank").text(),
      team: tr.find(".team-name").text(),
      points: tr.find(".totalpoints:not(.last)").text(),
      wins: tr.find(".totalpoints.last").text().split("-")[0],
      loss: tr.find(".totalpoints.last").text().split("-")[1]
    }

  robot.respond /standings/i, (msg) ->
    robot.http("http://football.fantasysports.yahoo.com/pickem/35306")
      .headers({
        # no yahoo api for this so idk?
        "Cookie": process.env.YAHOO_ACCESS_COOKIE
      })
      .get() (err, res, body) ->
        return msg.send "Error :: #{err}" if err

        $ = cheerio.load(body)

        standings = []

        for tr in $("#top-50 tbody tr")
          standings.push serializeRow($(tr))

        standings = _(standings)
          .chain()
          .sortBy("rank")
          .sortBy((s) -> s.team.toUpperCase())

        fields = [
          {
            title: "Rank",
            value: _.map(standings, (s) -> "#{s.rank}").join("\n"),
            short: true
          },
          {
            title: "Team",
            value: "Jon\nHarry\nMike\nFrank\nWade",
            short: true
          },
          {
            title: "Points",
            value: "Jon\nHarry\nMike\nFrank\nWade",
            short: true
          },
          {
            title: "Wins",
            value: "Jon\nHarry\nMike\nFrank\nWade",
            short: true
          },
          {
            title: "Loss",
            value: "Jon\nHarry\nMike\nFrank\nWade",
            short: true
          },
        ]

        robot.emit 'slack-attachment',
          message: msg.message
          content:
            text: "Attachement Demo Text"
            fallback: "Fallback Text"
            pretext: "This is Pretext"
            fields: fields
