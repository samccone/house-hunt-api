get       = require('request').get
root      = "http://api.walkscore.com/score?format=json&wsapikey=#{process.env['WALK_SCORE_KEY']}"
cache     = require 'memory-cache'
responder = require '../responder'

module.exports = (req, res) ->
  cacheKey = "#{req.params.address}-#{req.params.lat}"

  if(cached = cache.get(cacheKey))
    responder(req, res, cached)
    return

  get "#{root}&address=#{req.params.address}&lat=#{req.params.lat}&lon=#{req.params.lon}", (e, d) ->
    d = JSON.parse(d.body)
    cache.put(cacheKey, d)
    responder(req, res, d)
