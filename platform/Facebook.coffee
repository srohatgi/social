Platform = require('./Platform').Platform
Proxy = require('../Proxy').Proxy
crypto = require 'crypto'
util = require 'util'

class Facebook extends Platform
  constructor: (req)->
    console.log "Facebook ctor called"
    @signed_req = req.param 'signed_request'
    super
    
  preprocess: ->
    q = @signed_req.split /\./
    if q.length != 2 
      throw new Error "unable to parse signed_request: #{req.param 'signed_request'}"
      return
    sig = q[0]

    expected_sig = crypto.createHmac('sha256', process.env.FACEBOOK_APP_KEY)
                          .update(q[1])
                          .digest('base64')
                          .replace(/\+/g,'-')
                          .replace(/\=/g,'')
                          .replace(/\//g,'_')

    if sig != expected_sig
      throw new Error "signature doesn't match #{sig}, #{expected_sig}"
      return

    js = JSON.parse(new Buffer(q[1], 'base64').toString('ascii'))
    console.log "got the following payload #{util.inspect js}"

    if js['issued_at'] - (new Date()).getTime() > 86400000
      throw new Error "stale request recieved; will reject #{js['issued']}"
      return

    if js['user_id'] == null
      redirect_uri = encodeURIComponent 'http://localhost:3000/facebook/'
      auth_url =  "http://www.facebook.com/dialog/oauth"+
                  "?client_id=#{process.env.FACEBOOK_APP_ID}"+
                  "&redirect_uri=#{redirect_uri}"
      @html = "<script>top.location.href='#{auth_url}';</script>"
    else
      @html = "my facebook folders app: #{JSON.stringify js}"
    # TODO get access code
    @getAccessCode.call this, js.oauth_token  
    return
    
  getAccessCode: (oauth_token)->
    console.log "trying to get the facebook access code from oauth token(#{oauth_token})"
    redirect_uri = encodeURIComponent 'http://localhost:3000/facebook/'
    access_url =  "https://graph.facebook.com/oauth/access_token"+
                  "?client_id=#{process.env.FACEBOOK_APP_ID}"+
                  "&client_secret=#{process.env.FACEBOOK_APP_KEY}"+
                  "&redirect_uri=#{redirect_uri}"+
                  "&code=#{oauth_token}"
    p = new Proxy(access_url)
    p.execute (err,res)->
      throw new Error "Error getting Access Code #{err}" unless !err
      console.log "processing the result: #{res}"
      @access_code = res
      return
    return this
     
  post: ->
    @preprocess.call this, null
    @html
    
exports.Facebook = Facebook
