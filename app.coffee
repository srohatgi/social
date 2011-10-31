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

app.post '/facebook', (req, res) ->	
	r = new ROQL req, res
	r.execute()
	return

app.listen process.env.PORT

console.log "social server listening on port #{app.address().port} in #{app.settings.env} mode"

class BusinessObject
	constructor: ->
		console.log "inside BO ctor"
		
	post: ->
		console.log "base BO.post() no-op"
		return
		
	get: ->
		console.log "base BO.get() no-op"
		{message: 'Welcome to Tau framework'}
		
	put: ->
		console.log "base BO.put() no-op"
		return

class Facebook extends BusinessObject
	constructor: (req)->
		console.log "Facebook ctor called"
		@signed_req = req.param 'signed_request'
		super
		
	preprocess: ->
		q = signed_req.split /\./
		if q.length != 2 
			throw new Exception "unable to parse signed_request: #{req.param 'signed_request'}"
			return
		sig = q[0]

		expected_sig = crypto.createHmac('sha256', process.env.FACEBOOK_APP_KEY)
													.update(q[1])
													.digest('base64')
													.replace(/\+/g,'-')
													.replace(/\=/g,'')
													.replace(/\//g,'_')

		if sig != expected_sig
			throw new Exception "signature doesn't match #{sig}, #{expected_sig}"
			return

		js = JSON.parse(new Buffer q[1], 'base64').toString 'ascii'
		console.log "got the following payload #{JSON.stringify js}"

		if js['issued_at'] - (new Date()).getTime() > 86400000
			throw new Exception "stale request recieved; will reject #{js['issued']}"
			return

		if js['user_id'] == null
			redirect_uri = encodeUriComponent 'http://localhost:3000/facebook'
			auth_url = "http://www.facebook.com/dialog/oauth?client_id=#{process.env.FACEBOOK_APP_ID}&redirect_uri=#{redirect_uri}"
			@html = "<script>top.location.href='#{auth_url}';</script>"
		else
			@html "my facebook app: #{JSON.stringify js}"
		return
		
	post: ->
		preprocess
		@html

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
			@bo = new BO
		if @req.url == '/facebook'
			@bo = new Facebook @req
		return
		
	execute: ->
		console.log "inside ROQL.execute()"
		if @req.method == 'get'
			@res.send bo.get
		if @req.method == 'post'
			@res.send bo.post
		return
	
