ROQL
====
**Restful Object Query Language** is a library. Out of the box, it extends pointer like nature of the web addresses to being now an OO like query language. The library tries to do this extension in a way that appeals and appears as **natural** to web programmers.

KEYWORDS
--------
Programmers need to know and understand the domain objects exposed by the underlying corporation. These then become a part of the language. A way to rationalize this is to imagine that these business objects act as *global variables*

- **physical** objects
  - examples: person (user, account), device (desktop, mobile), content (folder, file, link), message (email, sms)
  - examples: time (date, last, days, weeks, months, years), transaction (id)
- **virtual** objects
  - examples: send, receive, track, share, sync, sign, upload, download, users, content-svc
- **common** methods: business objects are primarily acted upon (retrieved, managed, updated) from service methods
  - examples: new (HTTP POST), list (HTTP GET), update (HTTP PUT), details (HTTP GET)
  - custom: for example, *audit* is a new send object method primarily for updating audit details around send transaction (available on PUT)
- **extensions**: capability to add new objects and methods at runtime (immediately available for use)
  - examples: send method extension for notifying a custom webservice
  - examples: new business object (company) added as type person

SYNTAX
------
- object **methods invoked** using: <method>:<broker>/<object name>
  - examples: GET:t.yousendit.com/send; we can typically ignore the t broker, and shorten the object method invocation to GET:/send
- **parameters (we can imagine these as filters in a REST method)** are passed in using object notation
  - examples: person.user.login, person.user.email refers to same object (user) with two properties (login, email)
  - examples: person.user.login, person.account.name refers to two objects (user, account)
  - NOTE: object properties can be determined using shorthand notation of child classes, for example:
    - example: user.login is same as person.user.login
  - NOTE: to disambiguate two objects of the same type, arbitrary names can be prefixed
    - example: from.user.login is same as from.person.user.login
  - NOTE: to pass in an object array (named or otherwise), build two variables referring to same object
    - example: user.login=sumeet, user.login=yitao 
- **output selectors** these default to object definition; however data can be aggregated and output can be manipulated to a desired format/ form
  - examples: sum(user.income)
- environment when a user logs in to yousendit
  - the user is issued a session id
    - the session allows the user to 
  - the client app is issued a refresh token (allows app to generate a new session id on users behalf)

USE CASES
---------
With this vocabulary in mind, let us try to map certain operations.

**universe of all registered people**

    GET:/users
    {
        persons: 
      [
        { login: 'mihir', account: 'ysi', group: 'pm' },
        { login: 'sumeet', account: 'ysi', group: 'engg' },
        { login: 'ivan', account: 'ysi', group: 'exec' },
      ] 
      , next: IDNEXT
    }

NOTE: this list is scoped (narrowed) with users session id

**a person with login 'sumeet' within 'ysi' account**
    
    GET:/users/user.login/sumeet
    GET:/users/user.id/XXXX`
    {
         login: 'sumeet'
       , id: XXXX
       , type: 'person'
       , account: 'ysi'
       , devices: [ { name: 'windows', sso: 'true' }, { name: 'iphone', sso: 'false' } ]
       , email: 'sumeet@ysi.com'
     }

**details of named 'mypics' content owned by 'sumeet' of 'ysi' named account**
    
    GET:/content-svc?user.login=sumeet&user.account=ysi&content.name=mypics
    GET:/content-svc/content.id/XXXX
    {
         type: 'folder'
       , id: XXXX
       , details: { name: 'mypics', size: '200 GB', sub_folders: '20', files: '0' }
    }
     
**list of all files, links & folders of named account 'ysi'**
    
    GET:/content-svc?person.account=ysi
    {
          contents: 
          [
             { type: 'folder', name: 'partnerships'},
             { type: 'file', name: 'employeelist' }
          ] 
        , next: 'IDNEXT'
     }
     
**send a folder from a user to another user, using email**
    
    POST:/send
    from.user.email=s@s.com&to.user.email=y@y.com&content.folder.name=mypics&expiry.time.weeks=2
    {
        id: 'XXX'
     }
     
**last ten items that were sent by me**
    
    GET:/send:list?from.time.last=10
    {
      transactions: 
        [
          { date: '12/2/03', content: [ { subtype: 'file', name: 'agreement' }], recipient: [ {email: s@s.com} ] }
        , { date: '11/2/03', content: [ { subtype: 'folder', name: 'hawaii' }], recipient: [ {email: y@y.com} ] }
        ]
    }
    
**upload a folder**
    
    POST:/upload?content.type=folder&content.folder.name=mypics

**download a file**
    
    GET:/download/file.id/XXXX
    
**sign a document**
    
    GET:/sign?content

**synchronize a device directory**
    
    POST:/sync?device&folder
    
**update some details about a person**
    
    PUT:/users/person.id/XXXX?person.phone=4085188433
