GreatEffectTest    = require './test-greatEffect'
keyEffectLayerTest = require './test-keyEffectLayer'
ParserTest         = require './test-parser'
TimerTest          = require './test-timer'
NoteTest           = require './test-note'

window.onload = ->
  cc.game.onStart = ->
    cc.view.enableRetina off
    cc.view.adjustViewPort on
    policy = new cc.ResolutionPolicy cc.ContainerStrategy.ORIGINAL_CONTAINER, cc.ContentStrategy.SHOW_ALL
    cc.view.setDesignResolutionSize 640, 480, policy

    keyEffectLayerTest = new keyEffectLayerTest()
    greatEffectTest = new GreatEffectTest()
    parserTest = new ParserTest()
    timerTest  = new TimerTest()
    noteTest   = new NoteTest()

    keyEffectLayerTest.start()
    greatEffectTest.start()
    parserTest.start()
    timerTest.start()
    noteTest.start()

    if window.mochaPhantomJS
      mochaPhantomJS.run()
    else
      mocha.run()


  cc.game.run 'gameCanvas'
