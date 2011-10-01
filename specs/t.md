t
=
t (tau) is The overall framework for building lightwieght web apps. In the current incarnation, it leverages html5, css3, js standards for defining, executing applications across multiple devices.

Applications
------------
Each t application has an application descriptor. This descriptor wires up the application for deploying it in a t cloud.

Example application descriptor:

    var app1 = function(environment, onStart, onEnd) { 
      return {
        
      }
    }

Environment
-----------
A t environment is composed of:

 - stateless node.js server
 - platform services
   - document read/ writes services (mongo)
   - caching services (memcached)
   - file storage services (memcached)
   - other http business services (custom)

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
