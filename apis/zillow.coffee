request   = require 'request'
cache     = require 'memory-cache'
xml2js    = require('xml2js').parseString
responder = require '../responder'
baseAPI   = "http://www.zillow.com/webservice/"

getDemographics = (zip, cb) ->
  baseURL = "#{baseAPI}GetDemographics.htm?zws-id=#{process.env['ZILLOW_ID']}"
  request.get "#{baseURL}&zip=#{zip}", (e, d) ->
    xml2js d.body, cb

demographics = (req, res) ->
  baseURL = "#{baseAPI}GetDemographics.htm?zws-id=#{process.env['ZILLOW_ID']}"
  cacheKey = req.params.zip

  if cached = cache.get(cacheKey)
    responder(req, res, cached)
    return

  getDemographics req.params.zip, (e, d) ->
    cache.put(cacheKey, d)
    responder(req, res, d)

details = (req, res) ->
  cacheKey = "#{req.params.zpid}"
  if cached = cache.get(cacheKey)
    responder(req, res, cached)
    return

  request.get "#{baseAPI}GetDeepComps.htm?zws-id=#{process.env['ZILLOW_ID']}&zpid=#{req.params.zpid}&count=1", (e, d) ->
    xml2js d.body, (e, d) ->
      cache.put(cacheKey, d)
      responder(req, res, d)

search = (req, res) ->
  cacheKey = "#{req.params.zip}-demo"

  if cached = cache.get(cacheKey)
    responder(req, res, cached)
    return

  getDemographics req.params.zip, (e, d) ->
    regionId = d['Demographics:demographics']['response'][0]['region'][0]['id'][0]
    url = "http://www.zillow.com/search/GetRegionSelection.htm?regionId=#{regionId}"
    request.get url, (e, d) ->
      rect = JSON.parse(d.body).boundingRect
      url = "http://www.zillow.com/search/GetResults.htm?status=110011&lt=11110&ht=11111&pr=,&mp=,&bd=0%2C&ba=0%2C&sf=,&lot=,&yr=,&pho=0&pets=0&parking=0&laundry=0&pnd=0&red=0&zso=0&days=any&ds=all&pmf=1&pf=1&zoom=13&rect=#{rect.sw.lon},#{rect.sw.lat},#{rect.ne.lon},#{rect.ne.lat}&p=1&sort=days&search=map&disp=1&rid=58981&rt=7&listright=true&responsivemode=defaultList&isMapSearch=true&zoom=13"
      request.get url, (e, d) ->
        r = JSON.parse(d.body)
        r.map.properties.map (p) ->
          p[7][4] = p[7][4]?.replace?(/p_a/,"p_d")
          p

        cache.put(cacheKey, r)
        responder(req, res, r)

module.exports =
  demographics : demographics
  search       : search
  details      : details
