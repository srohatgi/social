express = require 'express'
crypto = require 'crypto'
util = require 'util'
ROQL = require('./ROQL').ROQL

app = module.exports = express.createServer()

app.configure ->
  app.set 'views', __dirname+'/views'
  app.set 'view engine', 'jade'
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use express.logger({format: ':method :url :response-time'})
  app.use app.router
  app.use express.static __dirname+'/public'
  
app.get '/', (req,res) ->
  r = new ROQL req, res
  r.execute()
  return
  
app.post '/', (req,res) ->
  r = new ROQL req, res
  r.execute()
  return

app.post '/facebook', (req, res) ->  
  console.log 'POST called on /facebook'
  r = new ROQL req, res
  r.execute()
  return

app.get '/facebook', (req, res) ->  
  console.log 'GET  called on /facebook'
  r = new ROQL req, res
  r.execute()
  return

app.listen process.env.PORT

console.log "social server listening on port #{app.address().port} in #{app.settings.env} mode"


