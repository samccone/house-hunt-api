http    = require 'http'
express = require 'express'
app     = express()
port    = process.env['PORT'] || 3333







app.get '/demographics/:zip', require('./apis/zillow').demographics
app.get '/homes/:zip', require('./apis/zillow').search

# (req, res) ->
#   req"address=#{address}"

#   res.json(
#     k: 1
#   )

app.listen port
console.log "app started on #{port}"