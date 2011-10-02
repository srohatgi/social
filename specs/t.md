t
=
t (tau) is The overall framework for building lightwieght web apps. In the current incarnation, it leverages html5, css3, js standards for defining, executing applications across multiple devices.


Applications
------------
A t app does the following:

 - queries the environment
   - gathers interaction mode for its use
 - knows to interact with its human users on devices
   - provides a set features to interact with browsers
     - URL locates a t app from the internet
     - GUI Elements to conduct information
       - HTML form elements
     - Mouse & Keyboard as affiliate devices to provide manipulation of information elements
   - provides a set of features to interact with devices  
     - Icon for activating an app
     - GUI Elements to conduct information
       - HTML form elements
     - Touch, GPS, Camera, Physics (Accelarometer)
 - knows to interact programmitically
   - URL to locate the application
   - API methods to get and set information
 - global information stored by all t apps
   - who used the app 
   - when it was used
   - what information 
     - served
     - updated
 - two main parts of a t app:
   - client
     - composed of a set of (HTML5) programs downloaded from the server
     - communicates with the server using a secure protocol
       - ROQL (Restful Object Query Language) over HTTPS
     - caches encrypted information locally for performance reasons
       - the encryption key is stored on the server
       - initial client authentication retrieves the key
   - server
     - stateless node.js server
     - platform services
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
