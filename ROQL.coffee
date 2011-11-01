BusinessObjectFactory = require('./BusinessObjectFactory').BusinessObjectFactory

class ROQL
  constructor: (@req, @res)->
    console.log "inside ROQL ctor"
    # determine business object
    # console.log "inside ROQL.parse() #{util.inspect @req}"
    @bo = BusinessObjectFactory.instantiate(@req.url,@req,@res)
    
  execute: ->
    console.log "inside ROQL.execute() #{@req.method} #{@req.url}"
    if @req.method == 'GET'
      @res.send @bo.get()
    if @req.method == 'POST'
      @res.send @bo.post()
    return
    
exports.ROQL = ROQL
