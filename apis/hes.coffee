cache     = require 'memory-cache'
HESScore  = require 'hes-score'
module.exports = (req, res) ->
  cacheKey = "#{req.body.zip}-#{JSON.stringify(req.body.details)}"

  if (cache.get(cacheKey))
    res.json(cache.get(cacheKey))
    return

  HESScore(
    req.body.zip,
    req.body.details,
    (d) ->
      cache.put cacheKey, d
      res.json(d)
  )
