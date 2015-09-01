
require('chai').should()

anybase = require '../javascript/anybase'


describe 'anybase', ->

  describe 'converts', ->

    it 'integers properly', ->
      anybase(10, 10, 10).should.equal '10'
      anybase(16, 10, 16).should.equal '10'
      anybase(15, 10, 16).should.equal 'f'
      anybase(255, 10, 16).should.equal 'ff'
      anybase(0, 10, 16).should.equal '0'
      anybase(1000000000, 10, 1000000000, true).should.eql [1, 0]
      anybase(2, 10, 2).should.equal '10'
      anybase(128, 10, 2).should.equal '10000000'
      anybase(-16, 10, 8).should.equal '-20'
      anybase(-10, 2, 10).should.equal '-2'
