BusinessObject = require('./BusinessObject').BusinessObject

class User extends BusinessObject
  constructor: (@req)->
    console.log "User() object"
    
  create: ->
    console.log "User.create()"
    
  retrieve: ->
    console.log "User.retrieve()"
    