Folder Share
============
Out of the numerous folder sharing applications existing on the internet today, this app will attempt to be different. Following are the high level goals:

Content
-------
- each uploaded folder is **public** by default
  - updates from 3rd parties go through community governance process
  - community governance is performed by users who have changed/ viewed folder information before
- each folder is rendered as a web page
  - each folder can be thought of as a website
- each file in the folder has its own web page
  - there can be annotations on each web page
  - users can comment on each file

Discovery
---------

Main means of discovering content:
- search 
- browse (similar to your desktop)
- follow interesting content and users

Following
---------
- users follow interesting users or a subset of thier content
- these *follow* turn into folders themselves

Objects & Methods
-----------------
Using [Social Design](http://lifetechno.blogspot.com/2011/10/social-software-what-is-social-software.html) thinking, following turns out to be methods and objects.

Folder Object

    var Folder = function() {
      return {
          add: function(comment)
        , subscribe: function(object /* user or folder */)
        , list: function(object /* user or folder */)
      };
    };
    
User Object
    
    var User = function() {
      return {
          add: function(text /* comment or status */)
        , subscribe: function(object /* user or folder */)
        , list: function(object /* user or folder */)
      };
    };
