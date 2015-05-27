TimerTest = require './test-timer'
NoteTest  = require './test-note'

window.onload = ->
  cc.game.onStart = ->
    cc.view.adjustViewPort on
    cc.director.setContentScaleFactor 2
    #cc.view.setDesignResolutionSize 320, 480, cc.ResolutionPolicy.SHOW_ALL

    timerTest = new TimerTest()
    noteTest  = new NoteTest()

    noteTest.start()
    timerTest.start()

    if window.mochaPhantomJS
      mochaPhantomJS.run()
    else
      mocha.run()


  cc.game.run 'gameCanvas'
