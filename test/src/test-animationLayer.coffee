AnimationLayerTest = cc.Class.extend
  start : ->
    describe 'animation layer class test', ->
      @timeout 10000
      AnimationLayer = require '../../src/animationLayer'
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
              x : size.width / 2
              y : size.height / 2
            bmp = new AnimationLayer skin, timer
            srcs = [
              '../res/test1.png'
              '../res/test2.png'
              '../res/test3.png'
            ]
            bmps = [
              {timing : 1000, id : 0}
              {timing : 2000, id : 1}
              {timing : 1000, id : 2}
            ]

            bmp.init srcs, bmps, ''
            @addChild bmp
            bmp.start()
            timer.start()

            setTimeout =>
              capture "test/capture/BmpLayer/bmp" + capNum++
              done()
            , 4100

        cc.director.runScene new TestScene()

module.exports = AnimationLayerTest


