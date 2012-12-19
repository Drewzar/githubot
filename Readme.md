# A Hubot-compatible Github API wrapper for Node.js #

[![Build Status]](http://travis-ci.org/iangreenleaf/githubot)

## Install ##

    npm install githubot

## Require ##

Use it in your Hubot script:

```coffeescript
module.exports = (robot) ->
  github = require('githubot')(robot)
```

Or use it on its own:

```coffeescript
github = require('githubot')
```

## Use ##

Make any call to the Github v3 API, get the parsed JSON response:

```coffeescript
github.get "https://api.github.com/users/iangreenleaf/gists", (gists) ->
  console.log gists[0].description

github.get "users/foo/repos", {type: "owner"}, (repos) ->
  console.log repos[0].url

data = { description: "A test gist", public: true, files: { "abc.txt": { content: "abcdefg" } } }
github.post "gists", data, (gist) ->
  console.log gist.url
```

## Authentication ##

If `process.env.HUBOT_GITHUB_TOKEN` is present, you're automatically authenticated. Sweet!

### Acquire a token ###

If you don't have a token yet, run this:

    curl -i https://api.github.com/authorizations -d '{"scopes":["repo"]}' -u "yourusername"

Enter your Github password when prompted. When you get a response, look for the "token" value.

## Bespoke API access ##

Mostly a work in progress, but here's a taste of what I have in mind:

```coffeescript
gh.branches "foo/bar", (branches) ->
  console.log branches[0].name
```

```coffeescript
# Branch from master
gh.branches( "foo/bar" ).create "my_radical_feature", (branch) ->
  console.log branch.sha

# Branch from another branch
gh.branches( "foo/bar" ).create "even_more_radical", from: "my_radical_feature", (branch) ->
  console.log branch.sha
```

```coffeescript
gh.branches( "foo/bar" ).delete "my_radical_feature", ->
  console.log "Deleted my branch!"
```

## Helpful Hubot ##

Hubot will log errors if a request fails.

If `process.env.HUBOT_GITHUB_USER` is present, we can help you guess a repo's full name:

```coffeescript
github.qualified_repo "githubot" # => "iangreenleaf/githubot"
```

This will happen with the bespoke methods as well:

```coffeescript
gh.branches "githubot", (branches) ->
```

### Options ###

* `HUBOT_GITHUB_TOKEN`: GitHub API token. Required to perform authenticated actions.

* `HUBOT_GITHUB_USER`: Default GitHub username to use if one is not given.

* `HUBOT_GITHUB_API`: The base API URL. This is useful for Enterprise Github installations.

  For example, `HUBOT_GITHUB_API='http://myprivate.github.int'`

* `HUBOT_CONCURRENT_REQUESTS`: Limits the allowed number of concurrent requests to the GitHub API. Defaults to 20.

## Contributing ##

Install the dependencies:

    npm install

Run the tests:

    make test
    make test-all # Runs additional slower "integration" style tests, generally not necessary

**Pull requests encouraged!**

I'm vastly more likely to merge code that comes with tests. If you're confused by the testing process,
ask and I can probably point you in the right direction.

## Thanks ##

[These lovely people have contributed to githubot](https://github.com/iangreenleaf/githubot/contributors).




[Build Status]: https://secure.travis-ci.org/iangreenleaf/githubot.png?branch=master
