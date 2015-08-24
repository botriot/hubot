# Description
#   Search iTunes for preview content
#
# Commands:
#   hubot gems me <query> - Search rubygems.org for a gem

module.exports = (robot) ->

  robot.respond /music( me)? (.*)/i, (msg) ->
    query = msg.match[2]
    robot.http("http://itunes.apple.com/search")
      .query({
        entity: "song",
        limit: "1",
        term: query
      })
      .get() (err, res, body) ->
        songs = JSON.parse(body)
        return msg.send "No tracks found." if songs.resultCount == 0
        track = songs.results[0]

        msg.send track.trackViewUrl
        msg.send track.artworkUrl100 unless robot.adapterName == "slack"
        msg.send "*#{track.trackName}*"
        msg.send "#{track.artistName} — #{track.collectionName}"
        msg.send track.previewUrl
