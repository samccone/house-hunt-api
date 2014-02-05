request = require 'request'
cache   = require 'memory-cache'
xml2js  = require('xml2js').parseString

demographics = (req, res) ->
  baseURL = "http://www.zillow.com/webservice/GetDemographics.htm?zws-id=#{process.env['ZILLOW_ID']}"
  cacheKey = req.params.zip

  if cached = cache.get(cacheKey)
    res.json(cached)
    return

  request.get "#{baseURL}&zip=#{req.params.zip}", (e, d) ->
    xml2js d.body, (e, d) ->
      cache.put(cacheKey, d)
      res.json d


search = (req, res) ->
  cacheKey = "#{req.params.zip}-demo"

  if cached = cache.get(cacheKey)
    res.json cached
    return

  demographics req,
    json: (d) ->
      regionId = d['Demographics:demographics']['response'][0]['region'][0]['id'][0]
      url = "http://www.zillow.com/search/GetRegionSelection.htm?regionId=#{regionId}"
      request.get url, (e, d) ->
        rect = JSON.parse(d.body).boundingRect
        url = "http://www.zillow.com/search/GetResults.htm?status=110011&lt=11110&ht=11111&pr=,&mp=,&bd=0%2C&ba=0%2C&sf=,&lot=,&yr=,&pho=0&pets=0&parking=0&laundry=0&pnd=0&red=0&zso=0&days=any&ds=all&pmf=1&pf=1&zoom=13&rect=#{rect.sw.lon},#{rect.sw.lat},#{rect.ne.lon},#{rect.ne.lat}&p=1&sort=days&search=map&disp=1&rid=58981&rt=7&listright=true&responsivemode=defaultList&isMapSearch=true&zoom=13"
        request.get url, (e, d) ->
          cache.put(cacheKey, JSON.parse(d.body))
          res.json JSON.parse(d.body)

module.exports =
  demographics : demographics
  search       : search
