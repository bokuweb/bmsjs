keyEffectLayerTest = cc.Class.extend
  start : ->
    describe 'key effect layer class test', ->
      @timeout 3000
      $ = require 'jquery'
      KeyEffectLayer = require '../../src/keyEffectsLayer'
      capture = require './test-utils'
        .capture
      expect  = chai.expect
      capNum = 0

      it 'key effect layer create and show test', (done)->
        TestScene = cc.Scene.extend
          onEnter : ->
            @_super()
            xList = [41,63,80,102,119,141,158,0]
            skin =
              y : 160
              turntableKeydownImage :
                src : "../res/turntable-keydown.png"
              whiteKeydownImage :
                src : "../res/white-keydown.png"
              blackKeydownImage :
                src : "../res/black-keydown.png"

            keyEffectLayer = new KeyEffectLayer()
            keyEffectLayer.init skin, xList
            @addChild keyEffectLayer
            promise = null
            index = 0
            promise = do ->
              d = new $.Deferred
              id = setInterval ->
                keyEffectLayer.show index, 0.1
                index += 1
                console.log xList.length
                capture "test/capture/keyEffect/keyEffect" + capNum++
                if xList.length is index
                  clearInterval id
                  d.resolve()
              , 20
              d.promise()
            promise.then -> done()

        cc.director.runScene new TestScene()

      before ->

      after ->


module.exports = keyEffectLayerTest


