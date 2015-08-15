BpmLayerTest = cc.Class.extend
  start : ->
    describe 'bpm layer class test', ->
      @timeout 10000
      Bpm = require '../../src/bpmLayer'
      Timer = require '../../src/timer'
      capture = require './test-utils'
        .capture
      expect  = chai.expect
      capNum = 0

      it 'bpm update test', (done)->
        TestScene = cc.Scene.extend
          onEnter : ->
            @_super()
            size = cc.director.getWinSize()
            timer = new Timer()
            skin =
              src    :  '../res/numeral-font.png'
              width  : 29.5
              height : 36.5
              scale  : 0.35
              margin : 5
              x : size.width / 2
              y : size.height / 2

            bpms = [
              {timing : 500, val : 100}
              {timing : 1000, val : 200}
              {timing : 1500, val : 300}
            ]

            bpm = new Bpm skin, timer, bpms
            bpm.init()
            @addChild bpm
            bpm.start()
            timer.start()

            setTimeout =>
              capture "test/capture/BpmLayer/bmp" + capNum++
            , 750

            setTimeout =>
              capture "test/capture/BpmLayer/bmp" + capNum++
            , 1250

            setTimeout =>
              capture "test/capture/BpmLayer/bmp" + capNum++
              done()
            , 2500

        cc.director.runScene new TestScene()

module.exports = BpmLayerTest


