var http = require('http')
  , https = require('https')
  , url = require('url')
  , xml2js = require('xml2js')
  , util = require('util');

var process_response = function (res, details, callback) {
  var res_data = '';
  console.info("got response status code: "+res.statusCode);

  res.on('data', function(chunk) { res_data += chunk; });
  res.on('close', function(err) {
    console.log("the server closed the response unexpectedly- error!!");
    callback(err);
  });

  res.on('end', function() { 
    // server signaling an error
    if ( res.statusCode != 200 ) {
      // console.log("returned data:%s headers:%s",JSON.stringify(res_data),JSON.stringify(res.headers));

      // handle redirect
      if ( res.statusCode < 400 && 
           res.statusCode >= 300 && 
           res.headers['content-type'] !== 'text/html') {
        console.log("redirecting...");
        webapi(res.headers["location"],details,callback);
        return;
      }
      console.log("erroring out");
      callback('error calling service:'+res.statusCode+' response data:'+res_data);
      return;
    }

    // ALL IS WELL
    
    // the result is soap, lets convert to json
    if ( options.headers['Content-Type'] === 'application/soap+xml;charset=UTF-8' ) {
      var parser = new xml2js.Parser();
      parser.addListener('end', function(result) {
        console.log(result);
        // remove soap cruft from json
        result = result["S:Body"]["ns2:"+details.name+"Response"]["return"];
        callback(null,result);
      });
      parser.parseString(res_data);
      return;
    }

    // regular json
    callback(null,JSON.parse(res_data));
  });
};

var webapi = function (uri, details, callback) {
  var params = url.parse(uri);

  var options = {
      host: params.hostname
    , port: params.port
    , path: params.pathname
    , method: details.method
    , headers: {
      'Connection': 'keep-alive'
    }
  };

  // any headers?
  for (var h in details) {
    if ( h !== 'method' && 
         h !== 'name' && 
         h !== 'data' ) 
      options.headers[h] = details[h];
  }

  console.log("calling service:%s/%s with payload:%s content-type:%s",
              uri,
              details.name,
              details.data,
              JSON.stringify(options.headers));

  var req;
  if ( params.protocol === 'http:' ) 
    req = http.request(options, function(res) { process_response(res,details,callback); });
  else
    req = https.request(options, function(res) { process_response(res,details,callback); });

  req.on('error', function (e) { 
    console.error("error [%s]",e);
    req.abort();
    callback(e);
  });

  // write data 
  if ( details.data ) req.write(details.data);

  // call
  req.end();
};

exports.CallMethod = CallMethod;
