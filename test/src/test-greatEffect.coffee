GreatEffectTest = cc.Class.extend

  start : ->
    describe 'great effect class test', ->
      @timeout 3000
      GreatEffect = require '../../src/greatEffect'
      capture = require './test-utils'
        .capture
      expect  = chai.expect
      capNum = 0

      it 'note create and update test', (done)->
        TestScene = cc.Scene.extend
          onEnter : ->
            @_super()
            params =
              width  : 80 / cc.director.getContentScaleFactor()
              height : 80 / cc.director.getContentScaleFactor()
              row    : 4
              colum  : 4
              delay  : 0.02
            effect = new GreatEffect '../res/great-effect.png', params
            effect.x = cc.director.getWinSize().width / 2
            effect.y = cc.director.getWinSize().height / 2
            @addChild effect
            effect.run()

            expect @children.length
              .to.be.equal 1

            setTimeout =>
              expect @children.length
                .to.be.equal 0
              done()
            , 1000

        cc.director.runScene new TestScene()

      before ->

      after ->


module.exports = GreatEffectTest


