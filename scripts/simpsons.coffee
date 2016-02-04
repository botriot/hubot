# standings-table
module.exports = (robot) ->
  robot.hear /simpsons( me)? (.+)/, (msg) ->
    query = msg.match[2]
    msg.http("https://frinkiac.com/api/search?q=#{query}")
      .header('Accept', 'application/json')
      .get() (err, res, body) ->
        try
          json = JSON.parse(body)
          return msg.send "Nothing found. Try again, for glaven out loud!" unless json.length > 0
          episode = json.pop()
          msg.http("https://frinkiac.com/api/caption?e=#{episode.Episode}&t=#{episode.Timestamp}")
            .header('Accept', 'application/json')
            .get() (err, res, body) ->
              try
                json = JSON.parse(body)
                return msg.send "Nothing found. Try again, for glaven out loud!" unless json.Subtitles
                subtitle = json.Subtitles.pop()
                msg.send("https://frinkiac.com/meme/#{subtitle.Episode}/#{episode.Timestamp}.jpg?lines=#{subtitle.Content}")
              catch error
                return msg.send "Glaven! Simpsons api down!"
        catch error
          return msg.send "Glaven! Simpsons api down!"
