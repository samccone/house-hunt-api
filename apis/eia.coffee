w         = require 'when'
fn        = require('when/node/function').call
get       = require('request').get
root      = "http://api.eia.gov/series?api_key=#{process.env['EIA_KEY']}&series_id="
cache     = require 'memory-cache'
responder = require '../responder'

module.exports = (req, res) ->
  STATE     = req.params.state.toUpperCase()
  cacheKey  = "trends-#{STATE}"

  # OIL
  oilTrends = "SEDS.DFRCD.#{STATE}.A"

  # ELEC
  elecTrends = "ELEC.PRICE.#{STATE}-RES.A"

  # GAS
  gasTrends = "NG.N3010#{STATE}3.A"

  # WOOD
  woodTrends = "SEDS.WDRCD.#{STATE}.A"


  if cached = cache.get cacheKey
    responder(req, res, cached)
    return

  w.all([fn(get, root+woodTrends),
    fn(get, root+gasTrends),
    fn(get, root+elecTrends),
    fn(get, root+oilTrends)]).then (d) ->
      d = d.map (v) -> JSON.parse(v[0].body)

      cache.put(cacheKey, d)
      responder(req, res, d)
