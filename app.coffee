express = require 'express'
crypto = require 'crypto'
util = require 'util'

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
	r.process()
	return
	
app.post '/', (req,res) ->
	r = new ROQL req, res
	r.execute()
	return

class BusinessObject
	constructor: ->
		console.log "inside BO ctor"

class ROQL
	constructor: (req, res)->
		console.log "inside ROQL ctor"
		@req = req
		@res = res
		parse

	parse: ->
		# determine business object
		console.log "inside ROQL.parse() #{util.inspect @req}"
		if @req.url == "/"
			console.log 'root directory, showing welcome message!'
			@res.send "Welcome to Tau Framework!"
		return
		
	execute: ->
		console.log "inside ROQL.execute()"
		return
	
app.post '/facebook', (req, res) ->	
	console.log "got request #{req.param 'signed_request'}"
	
	q = req.param('signed_request').split /\./
	if q.length != 2 
		res.send "unable to parse signed_request: #{req.param 'signed_request'}"
		return
	sig = q[0]
	
	expected_sig = crypto.createHmac('sha256', process.env.FACEBOOK_APP_KEY)
												.update(q[1])
												.digest('base64')
												.replace(/\+/g,'-')
												.replace(/\=/g,'')
												.replace(/\//g,'_')
	
	if sig != expected_sig
		res.send "signature doesn't match #{sig}, #{expected_sig}"
		return
		
	js = JSON.parse(new Buffer q[1], 'base64').toString 'ascii'
	console.log "got the following payload #{JSON.stringify js}"
	
	if js['issued_at'] - (new Date()).getTime() > 86400000
		res.send "stale request recieved; will reject #{js['issued']}"
		return
	
	if js['user_id'] == null
		redirect_uri = encodeUriComponent 'http://localhost:3000/facebook'
		auth_url = "http://www.facebook.com/dialog/oauth?client_id=#{process.env.FACEBOOK_APP_ID}&redirect_uri=#{redirect_uri}"
		res.send "<script>top.location.href='#{auth_url}';</script>"
	else
		res.send "my facebook app: #{JSON.stringify js}"
	return
		
app.listen process.env.PORT

console.log "social server listening on port #{app.address().port} in #{app.settings.env} mode"