# Description:
#   Corgime
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot corgi me - Receive a corgi
#   hubot corgi bomb N - get N corgis
#
# Author:
#   alexgodin

module.exports = (robot) ->

  robot.respond /corgi me/i, (msg) ->
    msg.http("http://corginator.herokuapp.com/random")
      .get() (err, res, body) ->
        msg.send JSON.parse(body).corgi

  robot.respond /corgi bomb( (\d+))?/i, (msg) ->
    count = msg.match[2] || 5
    if count > 10
      msg.send "I'm a robot, not a corgi machine. Please ask for less than 10 corgi."
    else
      msg.http("http://corginator.herokuapp.com/bomb?count=" + count)
        .get() (err, res, body) ->
          msg.send corgi for corgi in JSON.parse(body).corgis

