
var User = function() {
  return {
      register:
      function(profile) {
        // can we find the user?
        // no  - can we create a new user?
        //     - create a new user
        // create a session object; populate in profile
      }
    , add: 
      function(objectId, eventType, eventData) {
        // capture additional metadata: status, comments, message
        // let followers know of any interesting events
      }
    , subscribe: 
      function(objectId,callbackURL) {
        // interested followers
        // store objectId
        // store callbackURL
      }
    , list:
      function(eventType) {
        // sort by MRU; pagination
      }
  };
};

exports.User = User;
