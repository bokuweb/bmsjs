skin =
  rate :
    z : 10
    meter :
      src    : '../res/gauge.png'
      width  : 4
      height : 12
      x      : 122
      y      : 207
      z      : 10
    label :
      src    : '../res/numeral-font.png'
      width  : 29.5
      height : 36.5
      scale  : 0.3
      margin : 3
      x : 362
      y : 210

config =
  initRate    : 20
  great       : 1
  good        : 0.5
  bad         : -0.4
  poor        : -0.4
  num         : 50
  clearVal    : 40
  
RateLayerTest = cc.Class.extend
  start : ->
    describe 'rate layer class test', ->
      @timeout 10000
      RateLayer = require '../../src/rateLayer'
      capture = require './test-utils'
        .capture
      expect  = chai.expect
      capNum = 0

      it 'initialize rate and capture', (done)->
        TestScene = cc.Scene.extend
          onEnter : ->
            @_super()
            size = cc.director.getWinSize()
            rate = new RateLayer skin.rate
            rate.init config
            @addChild rate, skin.rate.z
            rate.start()

            setTimeout =>
              expect(rate.get()).to.be.equal config.initRate
              capture "test/capture/StatsLayer/stats" + capNum++
              done()
            , 1000
        cc.director.runScene new TestScene()

      it 'update rate by great', (done)->
        TestScene = cc.Scene.extend
          onEnter : ->
            @_super()
            size = cc.director.getWinSize()
            rate = new RateLayer skin.rate
            rate.init config
            @addChild rate, skin.rate.z
            rate.start()
            num = ~~(100 - config.initRate / config.great) + 1
            console.log num
            for i in [0...num]
              rate.reflect 'pgreat'

            setTimeout =>
              expect(rate.get()).to.be.equal 100
              capture "test/capture/StatsLayer/stats" + capNum++
              done()
            , 1000
        cc.director.runScene new TestScene()
        
module.exports = RateLayerTest


