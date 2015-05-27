TimerTest = cc.Class.extend
  start : ->
    describe 'timer class test', ->
      Timer  = require '../../src/timer'
      expect = chai.expect

      it 'should timer.get() return 0 before start', ->
        time = @_timer.get()
        expect time
          .to.be.equal 0

      it 'set timer 1000msec, should get() return about 1000msec', (done)->
        @_timer.start()
        test = =>
          console.log "test"
          time = @_timer.get()
          expect time
            .to.be.within 900, 1100
          done()
        setTimeout test, 1000

      before ->
        @_timer = new Timer()

module.exports = TimerTest


