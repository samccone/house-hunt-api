module.exports = (req, res, d) ->
  if req.query.callback?
    res.jsonp d
  else
    res.json d
