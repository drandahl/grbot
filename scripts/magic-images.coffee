# Description:
#   Returns image of magic cards
#
# Commands:
#   TBD

module.exports = (robot) ->
  robot.respond /magic( me)? (.*)/i, (msg) ->
    url = "http://mtgimage.com/card/#{encodeURIComponent(msg.match[2])}.jpg"
    msg.send(url)
