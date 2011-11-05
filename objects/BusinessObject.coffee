class BusinessObject
  constructor: (@req)->
    console.log "inside BO ctor"
    
  create: ->
    console.log "base BO.create() no-op"
    return
    
  retrieve: ->
    console.log "base BO.retrieve() no-op"
    {message: 'Welcome to Tau framework'}
    
  update: ->
    console.log "base BO.update() no-op"
    return
  
  list: ->
    console.log "base BO.list() no-op"
    return

exports.BusinessObject = BusinessObject
