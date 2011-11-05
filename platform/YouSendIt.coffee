Platform = require('./Platform').BusinessApp
Proxy = require('../Proxy').Proxy
crypto = require 'crypto'
util = require 'util'

class YouSendIt extends Platform
  constructor: (req)->
    console.log "YouSendIt ctor called"
    @access_token = req.param 'access_token'
    if !@access_token
      @email = req.param 'email'
      @password = req.param 'password'
    super

  preprocess: (proxy)->
    # build out and stitch in X-YSI-Signature
    string = """#{proxy.method}
#{proxy.getHeader('Content-MD5')}
#{proxy.getHeader('Content-Type')}
#{proxy.getHeader('Date')}
#{@ysi_auth_token}
#{proxy.getUrlPath()}
"""
    hmac = crypto.createHmac('sha256', process.env.YSI_API_SECRET)
                          .update(string)
                          .digest('base64')
                          .replace(/\+/g,'-')
                          .replace(/\=/g,'')
                          .replace(/\//g,'_')
    
    xysi_sig = "YSI #{process.env.YSI_API_KEY}:#{hmac}"
    proxy.headers([ {'X-YSI-Signature': xysi_sig} ])
    return
  
  getAuthToken: ->
    if @access_token
      return @access_token
    console.log "trying to get YouSendIt access code using email and password"
    p = new Proxy("https://developer-api.yousendit.com/v2/auth?email=#{@email}&password=#{@password}")
    @prepare.call this, p
    p.execute (err,res)->
      throw new Error "Error getting Access Code #{err}" unless !err
      console.log "processing the result: #{res}"
      @access_code = res
      return
    return this

  post: ->
    @preprocess.call this, null
    @html
    
exports.YouSendIt = YouSendIt
