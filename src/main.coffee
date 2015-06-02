# TODO : add arg path to bms etc.
cc.game.onStart = ->
  MenuScene = require './menuScene'
  Parser   = require './parser'
  resList  = require './resource'
    .resList

  if not cc.sys.isNative and document.getElementById "cocosLoading"
    document.body.removeChild(document.getElementById "cocosLoading")

  cc.view.enableRetina off
  cc.view.adjustViewPort on

  cc.log cc.sys.isNative

  if cc.sys.isMobile or cc.sys.isNative
    height =  cc.view.getFrameSize().height / cc.view.getFrameSize().width * 320
    cc.view.setDesignResolutionSize 320, height, cc.ResolutionPolicy.SHOW_ALL
    cc.view.resizeWithBrowserSize on
  else
    policy = new cc.ResolutionPolicy cc.ContainerStrategy.ORIGINAL_CONTAINER, cc.ContentStrategy.SHOW_ALL
    cc.view.setDesignResolutionSize 800, 600, policy
    cc.view.resizeWithBrowserSize off
  cc.director.setContentScaleFactor 2

  cc.LoaderScene.preload resList, ->
    cc.director.runScene new MenuScene()
  , this

cc.game.run()
