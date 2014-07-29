noflo = require 'noflo'
request = require 'request'

class FetchUrl extends noflo.AsyncComponent
  # icon: 'bars'
  description: 'Given an URL, fetch an URL and return its status, body and headers.'
  constructor: ->
    @inPorts =
      url: new noflo.Port
        datatype: 'string'
        required: true
        description: 'URL to be fetched'
    @outPorts =
      out: new noflo.Port
        datatype: 'object'
      error: new noflo.Port
        datatype: 'object'
    super('url')

  doAsync: (url, callback) ->
    @outPorts.out.connect()

    request.get url, {}, (error, response, body) =>
      if(!error)
        data =
          status: response.statusCode
          headers: response.headers
          body: body
        @outPorts.out.beginGroup url
        @outPorts.out.send data
        @outPorts.out.endGroup()
        return callback null
      else
        @outPorts.out.disconnect()
        return callback error

exports.getComponent = -> new FetchUrl
