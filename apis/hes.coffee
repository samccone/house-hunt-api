cache     = require 'memory-cache'
HESScore  = require 'hes-score'
module.exports = (req, res) ->
  cacheKey = "#{req.body.zip}-#{JSON.stringify(req.body.inputs)}"

  if (cache.get(cacheKey))
    res.json(cache.get(cacheKey))
    return

  HESScore(
    req.body.zip,
    # this is a hack because it seems like node_soap
    # can not serialize an array of multiple objects
    [req.body.inputs[0]],
    (d) ->
      cache.put cacheKey, d
      res.json(d)
  )
