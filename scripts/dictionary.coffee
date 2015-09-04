# Description:
#   Define words with hubot
#
# Commands:
#   hubot define <word> - Will get the definition of a word
#   hubot define -u <word> - Will get the urbandictionary definition of a word
#
# Author:
#   Jon Rohan <jon@jonrohan.me>


module.exports = (robot) ->

  respondWord = (msg, word) ->
    def = "*#{word.word}*"
    for gram, definitions of word.definitions
      def+= "\n\n_#{gram}_"
      for definition, i in definitions
        def += "\n> #{i+1}. #{definition.definition}\n_\"#{definition.example}\"_\n"
    def+= "\n_synonyms:_ #{word.synonyms.join(", ")}"
    msg.send def.replace /\n$/, ''

  robot.respond /define( \-{1,2}\w+)? ([\d\w\s]+)/i, (msg) ->
    operand = msg.match[1]
    word = msg.match[2]
    defined_word =
      word: word
      definitions: {}

    # switch operand
    #   when " -u", " --urban"
    robot.http("http://api.urbandictionary.com/v0/define")
      .query({
        term: word
      })
      .get() (err, res, body) ->
        return msg.send "Error :: #{err}" if err
        try
          words = JSON.parse(body)
        catch error
          return msg.send "Error :: Urbandictionary api error."

        return msg.send "Word not found." if words.list.length == 0

        defined_word.definitions["verb"] = [
          {
            definition: words.list[0].definition.replace(/\n/g, ''),
            example: words.list[0].example.replace(/[\n"]/g, '').replace(/[\r]/g, ' ')
          }
        ]

        defined_word["synonyms"] = words.tags

        respondWord(msg, defined_word)

      # else
      #   respondWord(defined_word)
