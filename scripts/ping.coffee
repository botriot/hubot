# Description:
#   Utility commands surrounding Hubot uptime.
#
# Commands:
#   hubot ping - Reply with pong
#   hubot echo <text> - Reply back with <text>
#   hubot time - Reply with current time
#   hubot uptime - Reply with robot uptime
#   hubot die - End hubot process

module.exports = (robot) ->

  robot.brain.on 'loaded', ->
    robot.brain.data.loadTime = Date.now()

  robot.respond /PING$/i, (msg) ->
    msg.send "PONG"

  robot.respond /ADAPTER$/i, (msg) ->
    msg.send robot.adapterName

  robot.respond /ECHO (.*)$/i, (msg) ->
    msg.send msg.match[1]

  robot.respond /TIME$/i, (msg) ->
    msg.send "Server time is: #{new Date()}"

  robot.respond /UPTIME$/i, (msg) ->
    now = Date.now()
    old = robot.brain.data.loadTime
    str = []

    uptimeParts = [
      {name: 'day', seconds: 86400},
      {name: 'hour', seconds: 3600},
      {name: 'minute', seconds: 60}
    ]

    uptime = Math.floor((now - old + 3600) / 1000)

    if uptime <= 0
      msg.send "I just woke up."
    else if uptime > 0
      for part in uptimeParts
        if uptime > part.seconds
          t = Math.floor(uptime / part.seconds)
          str.push("#{t} #{part.name}#{if t > 1 then "s" else ""}")
          uptime -= t * part.seconds

      if uptime > 0
        str.push("#{uptime} second#{if uptime > 1 then "s" else ""}")

      msg.send "I've been awake for #{str.join(', ')}."
    else
      msg.send "Depends, what day is it?"

  robot.respond /DIE$/i, (msg) ->
    msg.send "Goodbye, cruel world."
    process.exit 0
