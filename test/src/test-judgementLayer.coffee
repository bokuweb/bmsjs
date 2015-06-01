JudgementLayerTest = cc.Class.extend
  start : ->
    describe 'judgement layer class test', ->
      @timeout 10000
      JudgementLayer = require '../../src/judgementLayer'
      $ = require 'jquery'
      capture = require './test-utils'
        .capture
      expect  = chai.expect
      capNum = 0

      it 'show judgement test', (done)->
        TestScene = cc.Scene.extend
          onEnter : ->
            @_super()
            size = cc.director.getWinSize()
            judgement = new JudgementLayer
              judge :
                src    :  '../res/judge-image.png'
                width  : 51
                height : 15
                x : size.width / 2
                y : size.height / 2
            judgement.init()
            @addChild judgement

            showGreat = ->
              d = new $.Deferred
              judgement.show 0, 0, 0.5
              setTimeout ->
                capture "test/capture/judgementLayer/judgement" + capNum++
                d.resolve()
              , 400
              d.promise()

            showGood = ->
              d = new $.Deferred
              judgement.show 1, 0, 0.5
              setTimeout ->
                capture "test/capture/judgementLayer/judgement" + capNum++
                d.resolve()
              , 400
              d.promise()

            showBad = ->
              d = new $.Deferred
              judgement.show 2, 0, 0.5
              setTimeout ->
                capture "test/capture/judgementLayer/judgement" + capNum++
                d.resolve()
              , 400
              d.promise()

            showPoor = ->
              d = new $.Deferred
              judgement.show 3, 0, 0.5
              setTimeout ->
                capture "test/capture/judgementLayer/judgement" + capNum++
                d.resolve()
              , 400
              d.promise()

            showGreat()
              .then showGood
              .then showBad
              .then showPoor
              .then ->
                setTimeout ->
                  done()
                , 500

        cc.director.runScene new TestScene()

module.exports = JudgementLayerTest


