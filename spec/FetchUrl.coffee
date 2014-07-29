noflo = require 'noflo'
chai = require 'chai' unless chai
nock = require 'nock'
FetchUrl = require '../components/FetchUrl.coffee'

describe 'FetchUrl component', ->
  c = null
  url = null
  out = null
  scope = null

  beforeEach ->
    c = FetchUrl.getComponent()
    url = noflo.internalSocket.createSocket()
    out = noflo.internalSocket.createSocket()
    c.inPorts.url.attach url
    c.outPorts.out.attach out
    nock.disableNetConnect()

    reqMock = nock 'http://www.example.com'
            .get '/'
            .reply 200, 'Hello!'


  describe 'when instantiated', ->
    it 'should have an url port', ->
      chai.expect(c.inPorts.url).to.be.an 'object'
    it 'should have an output port', ->
      chai.expect(c.outPorts.out).to.be.an 'object'
    it 'should have an error port', ->
      chai.expect(c.outPorts.error).to.be.an 'object'

  describe 'fetching an existing URL', ->
    it 'should return contents as an object', (done) ->
      out.on 'data', (data) ->
        chai.expect(data).to.be.a 'object'
        chai.expect(data).to.contain.keys 'status', 'headers', 'body'
        console.log data
        # scope.done()
        done()
      url.send 'http://www.example.com/'

  describe 'fetching a failing URL', ->
    it 'should return an error', (done) ->
      err = noflo.internalSocket.createSocket()
      c.outPorts.error.attach err
      err.on 'data', (data) ->
        chai.expect(data).to.be.an 'object'
        done()
      url.send 'http://google.com/'
