TestEntryScene = require './test-entryScene'

window.onload = ->
  cc.game.onStart = ->
    cc.view.adjustViewPort on
    #cc.director.setContentScaleFactor 1
    #cc.view.setDesignResolutionSize 320, 480, cc.ResolutionPolicy.SHOW_ALL
    cc.LoaderScene.preload [], ->
      cc.director.runScene new TestEntryScene()
    , this

  cc.game.run 'gameCanvas'
