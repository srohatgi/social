class Platform
  constructor: (@req)->
    console.log "inside PFM ctor"
    
  post: ->
    console.log "base PFM.post() no-op"
    return
    
  get: ->
    console.log "base PFM.get() no-op"
    {message: 'Welcome to Tau framework'}
    
  put: ->
    console.log "base PFM.put() no-op"
    return

exports.Platform = Platform
