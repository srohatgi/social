t
=
**t** (**tau**) is the overall framework for building lightwieght social web apps. The distinction between tau social framework and other web application frameworks is to allow building of malleable application business objects, which expose data and behavior which can be changed by users.

Business Object
---------------
So what is a business object? In its purest form, a business object is just a bag of related structured data. For example, a user object looks like:

    User
    {
        id_: 'XXXXXX'
      , name: 'Sumeet Rohatgi'
      , dob: '1/1/1970'
      , address: { 
          street: '2345 Acme Ave'
        , city: 'AnyCity'
        , state: 'AC'
        , zip: '90210'
        }
    }
    
These objects can be created, destroyed, updated, and **related** to other business objects. There are two kinds of relations:

 - for example, a *Payment object* contains information about the user and the payment he made for a subscription or a service
 - for example, a *Payment object* is a type of an *Activity object* (a higher level abstraction)

**tau framework** aims to allow simple objects like **User** be used as building blocks for composing objects like **Payment**, **Activity** etc. 

Another unique aspect of **tau** framework are the applications.

t Applications
--------------
A **t app** does the following:

 - queries its environment
   - gathers appropriate interaction mode for its use
   - UI (HTML5/URL) or TEXT (JSON/REST)
 - two main parts of a t app:
   - client
     - composed of a set of (HTML5) programs downloaded from the server
       - to be run in the browser (can be an embedded browser - in case of device)
     - communicates with the server using a secure protocol (HTTPS)
     - caches encrypted information locally for performance reasons
       - the encryption key is stored on the server
       - initial client authentication retrieves the key
   - server
     - stateless application server communicating to 
     - platform services, examples:
       - document read/ writes services (mongo)
       - caching services (memcached)
       - file storage services (memcached)
       - other http business services (custom)

Application Descriptor
----------------------
Example application descriptor object:

    var app1 = function(environment, onStart, onEnd) { 
      var e = environment;
      return {
        
      }
    }

Environment
-----------
Example environment descriptor:
    
    var env = function(service_endpoints) {
      // validate endpoints are configured correctly
      var ua = "";
      var user = "";
      return {
          setup: function(roql) {
          // parse headers and setup ua, user etc.

        }
        , db: function() {
          return service_endpoints.mongo_db_uri;
        }
      }
    }
