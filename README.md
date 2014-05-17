# GRBOT - Goodreads Slackbot
Hosted on Heroku

## Contributing

1. Make sure you have all the dependencies you need to get started with [Hubot](http://hubot.github.com): `npm install -g hubot coffee-script`
2. Clone this repo
3. If you'd like a local copy of the dependencies, install them: `npm install` (this is really helpful if you want to add any of the community [hubot-scripts](https://github.com/github/hubot-scripts) becuase you'll get a local copy to reference)

### Adding new scripts
There are two ways you can add new scripts: one is to write them yourself and add them to the `/scripts` directory (be sure to add any related dependencies into `package.json`) and another is to include one of the community scripts by adding the name of the script into `hubot-scripts.json`.

Once you've added these and committed to git, open a pull request to this repo (temporary solution) to update the source code for everyone and (more importantly), push to Heroku (talk to Ben to for contributor access)! (And don't forget to config any env variables you may need for any scripts.)