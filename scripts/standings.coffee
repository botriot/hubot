# standings-table

cheerio = require "cheerio"
_ = require "underscore"

module.exports = (robot) ->

  yf_url = "http://football.fantasysports.yahoo.com"
  yf_pickem_group_id = 35306
  yf_pickem_group_url = "#{yf_url}/pickem/#{yf_pickem_group_id}"

  serializeRow = (tr) ->
    {
      rank: tr.find(".rank").text(),
      team: tr.find(".team-name").text(),
      team_url: yf_url + tr.find(".team a").attr('href'),
      points: tr.find(".totalpoints:not(.last)").text(),
      wins: tr.find(".totalpoints.last").text().split("-")[0],
      loss: tr.find(".totalpoints.last").text().split("-")[1]
    }

  robot.respond /standings/i, (msg) ->
    robot.http(yf_pickem_group_url)
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
          .sortBy((s) -> s.team.toUpperCase()).value()

        fields = [
          {
            title: "Rank",
            value: _.map(standings, (s) -> "#{s.rank} <#{s.team_url}|#{s.team}>").join("\n"),
            short: true
          },
          {
            title: "Points",
            value: _.map(standings, (s) -> "#{s.points} (#{s.wins}-#{s.loss})").join("\n"),
            short: true
          }
        ]


        group_name = $("#ysf-page-header h1").contents()[0].data.replace /\s$/, ''
        game_date = $("#progress-bar .game-dates.game-start").text()

        robot.emit 'slack-attachment',
          message: msg.message
          content:
            title: "Standings for the #{group_name} Pro Football Pick'em",
            title_link: yf_pickem_group_url,
            text: "The next game is #{game_date}"
            fallback: "Standings for the <#{yf_pickem_group_url}|#{group_name}> Pro Football Pick'em"
            fields: fields
