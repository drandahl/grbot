# Description:
#   Custom commands for bp_hubot
#
# Commands:
#   bird.*word - did you hear?

module.exports = (robot) ->
  robot.hear /bird.*word/i, (msg) ->
    msg.send "http://youtu.be/2WNrx2jq184"
