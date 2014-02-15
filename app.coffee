http    = require 'http'
express = require 'express'
app     = express()
port    = process.env['PORT'] || 3333

app.get '/demographics/:zip', require('./apis/zillow').demographics
app.get '/homes/:zip', require('./apis/zillow').search
app.get '/trends/:state', require('./apis/eia')
app.get '/', (req, res) ->
  res.send("
    '/demographics/:zip' <br>
    '/homes/:zip' <br>
    '/trends/:state'
  ")

app.listen port
console.log "app started on #{port}"
