BusinessObject = require('./BusinessObject').BusinessObject
Facebook = require('./Facebook').Facebook

class BusinessObjectFactory
  @instantiate: (name, req)->
    bo = null
    if name == '/'
      bo = new BusinessObject(req)

    if name == '/facebook/'
      bo = new Facebook(req)

    throw new Exception "Error no object of type #{name}" unless bo
    bo

exports.BusinessObjectFactory = BusinessObjectFactory
