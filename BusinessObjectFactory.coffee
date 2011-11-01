BusinessObject = require('./BusinessObject').BusinessObject
Facebook = require('./Facebook').Facebook

class BusinessObjectFactory
  @instantiate: (name, req)->
    switch name
      when '/'
        new BusinessObject(req)
      when '/facebook/'
        new Facebook(req)
      else throw new Exception "Error no object of type #{name}"

exports.BusinessObjectFactory = BusinessObjectFactory
