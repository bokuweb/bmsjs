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

      it 'initialize stats and capture stats', (done)->
        TestScene = cc.Scene.extend
          onEnter : ->
            @_super()
            size = cc.director.getWinSize()
            timer = new Timer()
            skin =
              src    :  '../res/numeral-font.png'
              width  : 25
              height : 37.1
              scale  : 0.6
              margin : 5
              x : size.width / 2
              y : size.height / 2

            bpms = [
              {timing : 1000, val : 100}
              {timing : 2000, val : 200}
              {timing : 3000, val : 300}
            ]

            bpm = new Bpm skin, timer, bpms
            bpm.init()
            @addChild bpm
            bpm.start()
            timer.start()

            setTimeout =>
              capture "test/capture/BpmLayer/bmp" + capNum++
            , 1200

            setTimeout =>
              capture "test/capture/BpmLayer/bmp" + capNum++
            , 2200

            setTimeout =>
              capture "test/capture/BpmLayer/bmp" + capNum++
              done()
            , 3200
            
        cc.director.runScene new TestScene()

module.exports = BpmLayerTest


