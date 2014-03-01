http    = require 'http'
express = require 'express'
app     = express()
port    = process.env['PORT'] || 3333
Zillow  = require('./apis/zillow')

app.use(express.json())
app.use(express.urlencoded())

app.all '*', (req, res, next) ->
  res.header "Access-Control-Allow-Origin", "*"
  res.header "Access-Control-Allow-Headers", "X-Requested-With"
  next()

app.get '/demographics/:zip',  Zillow.demographics
app.get '/homes/:zip',         Zillow.search
app.get '/details/:zpid',      Zillow.details
app.get '/trends/:state',      require('./apis/eia')
app.post '/score',             require('./apis/hes')

app.get '/', (req, res) ->
  res.send("
    'get /demographics/:zip' <br>
    'get /homes/:zip' <br>
    'get /trends/:state' <br>
    '/details/:zpid' <br>
    'post /score => {zip, inputs}'
  ")

app.listen port
console.log "app started on #{port}"
