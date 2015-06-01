PlaytimeLayerTest = cc.Class.extend
  start : ->
    describe 'playtime layer class test', ->
      @timeout 10000
      PlaytimeLayer = require '../../src/playtimeLayer'
      Timer   = require '../../src/timer'
      capture = require './test-utils'
        .capture
      expect  = chai.expect
      capNum = 0

      it 'initialize playtime and capture stats', (done)->
        TestScene = cc.Scene.extend
          onEnter : ->
            @_super()
            size = cc.director.getWinSize()
            timer = new Timer()

            skin =
              src : '../res/numeral-font.png'
              width  : 8
              height : 8
              scale  : 2
              minuite :
                x : size.width / 2 - 20
                y : size.height / 2
              second :
                x : size.width / 2 + 20
                y : size.height / 2

            playtime = new PlaytimeLayer skin, timer

            playtime.init()
            @addChild playtime
            playtime.start()
            timer.set 58000
            timer.start()
            setTimeout =>
              capture "test/capture/playtimeLayer/time" + capNum++
              done()
            , 5200
        cc.director.runScene new TestScene()

module.exports = PlaytimeLayerTest


