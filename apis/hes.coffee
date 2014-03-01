module.exports = (req, res) ->
  require('hes-score')(
    req.body.zip,
    req.body.details,
    (d) -> res.json(d)
  )
