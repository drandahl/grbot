# GRBOT - Goodreads Slackbot
Hosted on Heroku

## Contributing

1. Make sure you have all the dependencies you need to get started with [Hubot](http://hubot.github.com): `npm install -g hubot coffee-script`
2. Clone this repo
3. If you'd like a local copy of the dependencies, install them: `npm install` (this is really helpful if you want to add any of the community [hubot-scripts](https://github.com/github/hubot-scripts) becuase you'll get a local copy to reference)

### Adding new scripts
There are two ways you can add new scripts: one is to write them yourself and add them to the `/scripts` directory (be sure to add any related dependencies into `package.json`) and another is to include one of the community scripts by adding the name of the script into `hubot-scripts.json`.

Once you've added these and committed to git, open a pull request to this repo (temporary solution) to update the source code for everyone and (more importantly), push to Heroku (talk to Ben to for contributor access)! (And don't forget to config any env variables you may need for any scripts.)

## Notes

Currently grbot only operates on a list of whitelisted channels. Once you have Heroku access, you can set the list of channels to be whitelisted with the following command, separating channels by commas: 
`heroku config:add HUBOT_SLACK_CHANNELS=general,random`. (Important: when setting this variable, make sure you don't override existing configs - I don't *think* there's a way to *add* a channel to this config, you always have to set the full value.)

To change the policy from whitelist to blacklist, try this: 
`heroku config:add HUBOT_SLACK_CHANNELMODE=blacklist` (and vice versa).

Take a look at the output from `heroku config` to see what other configs are set. Some details on what has already been set (some defined by [Slack](http://slack.com) configs, others by specific script requirements):

| Config | Description | Owner* |
|--------|-------------|-------|
| `HEROKU_URL` | prevents the app from sleeping automatically (Heroku apps wind down by default for the unpaid/free tier) | `none` |
| `HEROKU_SLACK_BOTNAME` | what the bot responds to in channels | `none` |
| `HEROKU_SLACK_CHANNELMODE` | whitelist or blacklist | `none` |
| `HEROKU_SLACK_CHANNELS` | channels to apply `CHANNELMODE` | `none` |
| `HEROKU_SLACK_TEAM` | team recognized by Slack | `none` |
| `HEROKU_SLACK_TOKEN` | unique token generated from Slack integrations | `none` |
| `REDISCLOUD_URL` | [RedisCloud](https://addons.heroku.com/rediscloud) addon for a free tier of Redis storage (`redis-brain.coffee`) | `none` |
| `HEROKU_BITLY_ACCESS_TOKEN` | used for [bitly](http://bit.ly) API (`bitly.coffee`) | Ben |
| `HEROKU_GIPHY_API_KEY` | used for [gifphy](http://giphy.com) API (`giphy.coffee`) | Ben |
| `HEROKU_ROTTEN_TOMATOES_API_KEY` | API key, blah blah | Ben |

\* Owner is the person you should contact regarding a particular config because the actual value was added by him/her and may be owned by a personal account

