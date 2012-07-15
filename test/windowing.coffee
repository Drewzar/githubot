# For some reason nock doesn't play nice with localhost in node 0.4, so
# avoid test_helper.coffee altogether here.
mock_robot = logger: { error: (->), debug: (->) }, clean: (->)
assert = require "assert"
http = require "http"

describe "concurrent requests", ->
  it "are limited", (done) ->
    maxRequests = 0
    remain = 100
    port = 7329
    active = 0

    server = http.createServer (req, res) ->
      active++
      assert.ok active <= 35
      maxRequests = Math.max maxRequests, active
      setTimeout ->
        active--
        res.end()
      , 10
    server.listen port

    process.env.HUBOT_GITHUB_API = "http://localhost:#{port}"
    process.env.HUBOT_CONCURRENT_REQUESTS = 35
    gh = require("..") mock_robot
    for i in [1..remain]
      gh.request "GET", "/repos/foo/bar/branches/#{i}", ->
        if --remain is 0
          assert.equal 35, maxRequests
          done()
    delete process.env.HUBOT_GITHUB_API
    delete process.env.HUBOT_CONCURRENT_REQUESTS
