var   express = require('express')
    , util = require('util')
    , crypto = require('crypto');

var app = module.exports = express.createServer();

// Configuration

app.configure(function(){
  app.set('views', __dirname + '/views');
  app.set('view engine', 'jade');
  app.use(express.bodyParser());
  app.use(express.methodOverride());
  app.use(express.logger({ format: ':method :url :response-time' }));
  app.use(app.router);
  app.use(express.static(__dirname + '/public'));
});

app.configure('development', function(){
  app.use(express.errorHandler({ dumpExceptions: true, showStack: true })); 
});

app.configure('production', function(){
  app.use(express.errorHandler()); 
});

// Routes
app.get('/', function (req, res) { roql(req, res); });
app.post('/', function (req, res) { roql(req, res); });

app.get('/facebook',function(req, res){
  var code = req.param('code');
  console.log("refresh code:"+code);
  var fb_api = "https://graph.facebook.com/oauth/access_token"+
               "?client_id="+process.env.FACEBOOK_APP_ID+
               "&redirect_uri="+encodeURIComponent("http://localhost:3000/facebook/")+
               "&client_secret="+process.env.FACEBOOK_APP_KEY+
               "&code="+code;
  res.send("Hello World");
});

app.post('/facebook',function(req, res){
  console.log("got signed_request:"+req.param('signed_request'));

  // parse out the request signature
  var q = req.param('signed_request').split(/\./);
  if ( q.length != 2 ) {
    res.send("unable to parse out signature from signed_request: "+req.param('signed_request'));
    return;
  }

  // verify signature
  var sig = q[0];
  var expected_sig = crypto.createHmac('sha256',process.env.FACEBOOK_APP_KEY)
                           .update(q[1])
                           .digest('base64')
                           .replace(/\+/g,'-')
                           .replace(/\=/g,'')
                           .replace(/\//g,'_');
  if ( sig != expected_sig ) {
    res.send("request signature does not match:"+sig+","+expected_sig);
    return;
  }

  // get the data payload from base 64 to ascii to parsed as JS
  var js = JSON.parse(new Buffer(q[1], 'base64').toString('ascii'));

  // verify that the payload was issued within the last day
  var dt = new Date();
  if ( js['issued_at'] - dt.getTime() > 86400000 ) {
    res.send("stale request (issued a day before); please refresh your browser to resend request");
    return;
  }

  console.log("got the following payload:"+JSON.stringify(js));

  if ( js['user_id'] == null ) {
    redirect_uri=encodeURIComponent("http://localhost:3000/facebook/");
    app_id=process.env.FACEBOOK_APP_ID;
    auth_url="http://www.facebook.com/dialog/oauth?client_id="+app_id+"&redirect_uri="+redirect_uri;
    res.send("<script>top.location.href='"+auth_url+"';</script>");
    return;
  }
  else {
    res.send("my facebook app: "+JSON.stringify(js));
    return;
  }
});

app.listen(process.env.PORT);
console.log("social server listening on port %d in %s mode", app.address().port, app.settings.env);
