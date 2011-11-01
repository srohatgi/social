class BusinessObject
  constructor: (@req)->
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

exports.BusinessObject = BusinessObject
