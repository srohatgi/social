
instantiate_platform = (name)->
  YouSendIt = require('./platform/YouSendIt').YouSendIt
  Facebook = require('./platform/Facebook').Facebook
  m = name.match /\/(\w+)/
  throw new Error "unable to match URL #{name}" unless m != null
  switch m[1].toLowerCase()
    when 'yousendit' then new YouSendIt(req)
    when 'facebook' then new Facebook(req)
    else throw new Error "Error no app factory of type #{m[1]}"
      
instantiate_businessobject = (url, req)->
  User = require('./objects/User').User
  File = require('./objects/File').File

  m = name.match /\/\w+\/(\w+)/
  throw new Error "unable to match any business object #{name}" unless m != null
  switch m[1].toLowerCase()
    when 'user' then new User(url,req)
    when 'file' then new File(url,req)
    else throw new Exception "Error no object of type #{m[1]}"

class ROQL
  constructor: (@req, @res)->
    console.log "inside ROQL ctor"
    # determine business app
    # console.log "inside ROQL.parse() #{util.inspect @req}"
    @pfm = instantiate_platform(@req.url)
    @obj = instantiate_businessobject(@req.url)
    
  execute: ->
    console.log "inside ROQL.execute() #{@req.method} #{@req.url}"
    if @req.method == 'GET'
      @res.send @bo.get()
    if @req.method == 'POST'
      @res.send @bo.post()
    return
    
  
    
exports.ROQL = ROQL
