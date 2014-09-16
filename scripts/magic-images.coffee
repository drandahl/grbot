# Description:
#   Returns image of magic cards
#
# Commands:
#   TBD

#$ion_1_0
#{
#Results:[
#  {
#    ID:"9763",
#    Name:"Team Spirit",
#    Group:null,
#    Snippet:"All creatures controlled by target player and his or her teammates get +1/+..."
#  },
#  {
#    ID:"74458",
#    Name:"Teardrop Kami",
#    Group:null,
#    Snippet:"Sacrifice Teardrop Kami: You may tap or untap target creature."
#  },
#],
#SearchCharacters:"te"
#}

module.exports = (robot) ->

  robot.respond /magic( me)? (.*)/i, (msg) ->
    magicSearch msg, (name) ->
      if name
        url = "http://mtgimage.com/card/#{name}.jpg"
        msg.send(url)
      else
        msg.send('No card found')

magicSearch = (msg, callback) ->
  searchUrl = "http://gatherer.wizards.com/Handlers/InlineCardSearch.ashx?nameFragment=#{encodeURIComponent(msg.match[2])}"
  msg.http(searchUrl)
  .get() (err, res, body) ->
    cards = JSON.parse(body)['Results']
    if cards.length > 0
      callback encodeURIComponent(cards[0]['Name'])
    else
      callback false







