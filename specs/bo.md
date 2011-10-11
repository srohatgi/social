Business Objects
================
Business Objects are strategic technology assets which perform all value added activities for a software business. These objects become so permeated that they formulate thier own vernacular over time. Keeping this in mind, these objects need to be designed and named with extra care so as to allow these objects to not only have long lifetimes, but also keeping track of changes over time.

Types
-----
- physical business objects
  - examples: person (user, account), device (desktop, mobile), content (folder, file, link), message (email, sms)
  - examples: time (date, last, days, weeks, months, years), transaction (id)
- digital business objects
  - examples: session (cookie, request)
- service business objects
  - examples: send, receive, track, share, sync, sign, upload, download, users, content-svc
- extension business objects: capability to add new objects and methods at runtime (immediately available for use)
  - examples: send method extension for notifying a custom webservice
  - examples: new business object (company) added as type person

Person
------
One of the fundamental business objects. This object represents a human being (user) or any entity related to human beings (account).

JSON representation:

    {
        name: ''
      , created: { by: X, date: C }
      , updated: { by: X, date: U }
    }

User
----
Object of `type` Person. 

    {
        type: 'Person'
      , name: ''
      , created: { by: X, date: C }
      , updated: { by: X, date: U }
      , sex: M
      , dob: D
      , login: L
      , emails: [e1, e2, e3]
    }

Account
-------
Object of `type` Person.

    {

    }
