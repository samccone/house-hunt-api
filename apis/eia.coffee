w       = require 'when'
fn      = require('when/node/function').call
get     = require('request').get
root    = "http://api.eia.gov/series?api_key=#{process.env['EIA_KEY']}&series_id=SEDS."
cache   = require 'memory-cache'

module.exports = (req, res) ->
  STATE     = req.params.state
  cacheKey  = "trends-#{STATE}"

  # OIL
  oilTrends = "DFRCD.#{STATE}.A"

  # ELEC
  elecTrends = "ESRCD.#{STATE}.A"

  # GAS
  gasTrends = "NGRCD.#{STATE}.A"

  # WOOD
  woodTrends = "WDRCD.#{STATE}.A"


  if cached = cache.get cacheKey
    res.json cached
    return

  w.all([fn(get, root+woodTrends),
    fn(get, root+gasTrends),
    fn(get, root+elecTrends),
    fn(get, root+oilTrends)]).then (d) ->
      res.json cache.put(cacheKey, d.map (v) -> JSON.parse(v[0].body))