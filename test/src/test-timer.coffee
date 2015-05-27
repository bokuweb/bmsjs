$ = require 'jquery'

TimerTest = cc.Class.extend
  start : ->
    describe 'timer class test', ->
      @timeout 10000
      Timer  = require '../../src/timer'
      expect = chai.expect

      it 'should timer.get() return 0 before start', ->
        time = @_timer.get()
        expect time
          .to.be.equal 0

      it 'set timer 1000msec, should get() return about 1000msec', (done)->
        @_timer.start()
        setTimeout =>
          time = @_timer.get()
          expect time
            .to.be.within 900, 1100
          @_timer.stop()
          done()
        , 1000

      it 'timer pause test, should timer return about 2000msec', (done)->
        @_timer.start()
        pause1secAfter = =>
          d = new $.Deferred
          setTimeout =>
            @_timer.pause()
            d.resolve()
          , 1000
          d.promise()

        restart1secAfter = =>
          d = new $.Deferred
          setTimeout =>
            @_timer.start()
            d.resolve()
          , 1000
          d.promise()

        check1secAfter = =>
          d = new $.Deferred
          setTimeout =>
            d.resolve()
          , 1000
          d.promise()

        pause1secAfter()
          .then restart1secAfter
          .then check1secAfter
          .then =>
            time = @_timer.get()
            expect time
              .to.be.within 1900, 2100
            done()

      before ->
        @_timer = new Timer()

module.exports = TimerTest


