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
 - client
   - composed of a set of (HTML5) programs downloaded from the server
     - to be run in the browser (can be an embedded browser, as in case of a mobile device)
     - able to tune the interactions based on UA (user agent), for example if the app is being rendered on mobile; then touch, swipe, and gravity become dominant means of interaction
   - composed of a set of text files (JSON) downloaded from the server
     - to be called using **curl** or the **browser** address bar
   - caches encrypted information locally for performance reasons
     - the encryption key is stored on the server
     - initial client authentication retrieves the key
   - communicates with the server using a secure protocol (HTTPS)
 - server
   - stateless application server components communicating to 
   - platform services, examples:
     - document read/ writes services (mongo)
     - caching services (memcached)
     - file storage services (memcached)
     - other http business services (custom)

Architecture
------------
A t app is stateless in nature and depends on a srtong **data services platform** to perform the heavy lifting of aggregation and composition. A N-tier architecture can be visualized where:

- business object definition, and operations are defined by developers
  - application compositing performed by a frontend generation layer (JET)
  - object retrieval and aggregation by a frontend parsing layer (ROQL)
  - compositional services performed by a **special data service** 
