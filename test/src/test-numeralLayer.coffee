NumeralLayerTest = cc.Class.extend

  start : ->
    describe 'numeral layer class test', ->
      @timeout 10000
      NumeralLayer = require '../../src/numeralLayer'
      capture = require './test-utils'
        .capture
      expect  = chai.expect
      capNum = 0

      it 'numeral layer create and reflect test', (done)->
        TestScene = cc.Scene.extend
          onEnter : ->
            @_super()

            numeralLayer = new NumeralLayer
              src    :  '../res/numeral-font.png'
              width  : 29.5
              height : 36.5
              scale  : 0.35
              margin : 3
            numeralLayer.init 10, 0
            size = cc.director.getWinSize()
            numeralLayer.x = size.width / 2
            numeralLayer.y = size.height / 2
            @addChild numeralLayer

            expect @children.length
              .to.be.equal 1

            setTimeout =>
              numeralLayer.reflect 123456789
              capture "test/capture/numeralLayer/num" + capNum++
            , 1000

            setTimeout =>
              numeralLayer.reflect 9876543210
              capture "test/capture/numeralLayer/num" + capNum++
            , 2000

            setTimeout =>
              capture "test/capture/numeralLayer/num" + capNum++
              done()
            , 3000

        cc.director.runScene new TestScene()

      it 'numeral layer create and reflect test x2', (done)->
        TestScene = cc.Scene.extend
          onEnter : ->
            @_super()

            numeralLayer = new NumeralLayer
              src    :  '../res/numeral-font.png'
              width  : 29.5
              height : 36.5
              scale  : 0.7
              margin : 3
            numeralLayer.init 10, 0
            size = cc.director.getWinSize()
            numeralLayer.x = size.width / 2
            numeralLayer.y = size.height / 2
            @addChild numeralLayer

            expect @children.length
              .to.be.equal 1

            setTimeout =>
              numeralLayer.reflect 123456789
              capture "test/capture/notes/notes" + capNum++
            , 1000

            setTimeout =>
              numeralLayer.reflect 9876543210
              capture "test/capture/notes/notes" + capNum++
            , 2000

            setTimeout =>
              capture "test/capture/notes/notes" + capNum++
              done()
            , 3000

        cc.director.runScene new TestScene()

      before ->

      after ->

module.exports = NumeralLayerTest


