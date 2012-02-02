http = require "scoped-http-client"

module.exports = (robot) -> {
  qualified_repo: (repo) ->
    repo = repo.toLowerCase()
    return repo unless repo.indexOf("/") is -1
    unless (user = process.env.HUBOT_GITHUB_USER)?
      throw "Default Github user not specified"
    "#{user}/#{repo}"
  get: (url) ->
    if url[0..3] isnt "http"
      url = "/#{url}" unless url[0] is "/"
      url = "https://api.github.com#{url}"
    req = http.create(url).header("Accept", "application/json")
    req = req.header("Authorization", "token #{oauth_token}") if (oauth_token = process.env.HUBOT_GITHUB_TOKEN)?
    req.get()
}
