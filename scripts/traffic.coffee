# Description:
#   Traffic maps
#
# Commands:
#   hubot traffic me <query>

# To get an ID:
#  1. do a google search for "<x> traffic map"
#  2. Right click the "Current traffic for <x>" image and copy source
#  3. The ID is the data= portion after the comma
# TODO: could scrape the Google search page, but that is against TOS.

places =
  sf: "VLHX1wd2Cgu8wR6jwyh-km8JBWAkEzU4,tZocgxvWAcTywomOMvllT9XDOCpzUBOM9VW9pK0UQe4biuqRxcqost7O6iwoTKqUCtvFCS2SX8bqzEsZAsCFS4xh16gHzRgDEC7TNoKsNIyoxz85Cf69WXL4uW--egMITmwH2_7S6tLo"
  soma: "VLHX1wd2Cgu8wR6jwyh-km8JBWAkEzU4,CNkbeItGrdBHbVbMcJ_QWFRIdehxva2Y35sf0qMbsWcVZXRpEA_rcJmrSzgL_KDfqRZqPUImImDHombB-R6j66gpBGSQuRy7NiwtuIrC0ve0U-u2LblDLShgGgwJxZN-YWMSsPSod4ij"
  pdx: "VLHX1wd2Cgu8wR6jwyh-km8JBWAkEzU4,oPS-VF0oHtuj2rqxDkht2kFuymEnnaX9J1oyowbjSE81BBEvlSNtUawFqZ2AivccQ2xseGkxQ3WfsYi9CocksQBkLxgvn2qnRtnk24osoMHqUvRD4eiep-m_mLqgZwjiF87A6xATrsdG"

defaultPlace = "sf"


module.exports = (robot) ->
  robot.respond /traffic( me)?( (.*))?/i, (msg) ->
    id = places[msg.match[3] or defaultPlace]
    if id
      msg.send "https://www.google.com/maps/vt/data=#{id}##{Date.now()}.png"
    else
      msg.send "I only have traffic configured for: #{Object.keys(data).join(', ')}"
