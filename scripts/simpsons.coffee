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
          episode = json.reverse().pop()
          msg.http("https://frinkiac.com/api/caption?e=#{episode.Episode}&t=#{episode.Timestamp}")
            .header('Accept', 'application/json')
            .get() (err, res, body) ->
              try
                json = JSON.parse(body)
                return msg.send "Nothing found. Try again, for glaven out loud!" unless json.Subtitles
                caption = ""
                for subtitle in json.Subtitles
                  formatted = ""
                  length = 0
                  for word in subtitle.Content.split(" ")
                    formatted += "#{word} "
                    length = formatted.length
                    if length >= 20
                      formatted += "\n"
                      length = 0
                  caption += "#{formatted}\n"
                msg.send("https://frinkiac.com/meme/#{subtitle.Episode}/#{episode.Timestamp}.jpg?lines=#{encodeURIComponent(caption.trim())}")
              catch error
                return msg.send "Glaven! Simpsons api down!"
        catch error
          return msg.send "Glaven! Simpsons api down!"
