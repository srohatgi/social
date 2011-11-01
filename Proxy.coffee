http = require 'http'
https = require 'https'
url = require 'url'
xml2js = require 'xml2js'
util = require 'util'

class Proxy
  constructor: (@uri, method = 'GET', @data = null)->
    params = url.parse uri
    @options = host: params.hostname, port: params.port, path: params.pathname, headers: { Connection: 'keep-alive' }
    @options.isSecure = true unless params.protocol == 'http:' 
    console.log "options: #{util.inspect @options}"
  
  soap: (name)->
    @options.name = {name}
    @options.isSoap = true
    this
  
  headers: (headers)->
    for k,v of headers
      @options.headers[k] = v
    this
  
  execute: (fn)->
    console.log "inside Proxy.execute()"
    @options.fn = fn
    if @options.isSecure
      @req = http.request @options, (res)=>
        @process.call this, res
        return
    else
      @req = https.request @options, (res)=>
        @process.call this, res
        return
    
    @req.on 'error', (err)-> 
      console.error "error in calling #{@uri} #{err}"
      @req.abort()
      fn(err)
      
    @req.write @data unless @data == null
    
    @req.end()
    this
    
  process: (res)->
    console.log "response status code: #{res.statusCode}"
    res_data = ''
    res.on 'data', (chunk)-> 
      res_data += chunk
      return 
    res.on 'close', (err)-> throw new Exception "Error: server closed connection: #{err}"
    res.on 'end', ->
      if res.statusCode != 200
        if res.statusCode < 400 && res.statusCode >= 300 && res.headers['content-type'] != 'text/html'
          console.log "redirecting to #{res.headers['location']}"
          @process this, res
          return
        console.log "will not handle return code: #{res.statusCode}"
        throw new Exception "Error: server returned status: #{res.statusCode}"
      
      # return code is 200
      
      # TODO: test REST/ XML
      if res.headers['Content-Type'] == 'application/soap+xml;charset=UTF-8' ||
         res.headers['Content-Type'] == 'application/text+xml;charset=UTF-8'
        parser = new xmlj2s.Parser()
        parser.addListener 'end', (result)->
          console.log result
          # for SOAP calls, remove the verbose cruft
          if res.headers['Content-Type'] == 'application/soap+xml;charset=UTF-8'          
            result = result['S:Body']["ns2:#{@options.name}Response"]["return"]
          @options.fn(null,result)
          return
        parser.parseString res_data
      else
        @options.fn null, JSON.parse(res_data)
      return
    this

exports.Proxy = Proxy