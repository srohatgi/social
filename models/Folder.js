
var Folder = function() {
  return {
      register:
      function(profile) {
        // populate folder 
      }
    , add: 
      function(objectId, infoType, infoData) {
        // capture additional metadata: status, comments, message
        // let followers know of any interesting events
      }
    , subscribe: 
      function(objectId,objectCallback) {
        // interested followers
      }
    , list:
      function(infoType) {
      }
  };
};

exports.Folder = Folder;
