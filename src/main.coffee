window.bmsStart = (pathToBmsDir) ->

  cc.pathToBmsDir = pathToBmsDir
  
  unless cc.sys.isNative
    cc.screenSize = window.parent.screen
  cc.game.run()

  cc.game.onStart = ->
    MenuScene   = require './menuScene'
    resList     = require './resource'
      .resList

    if not cc.sys.isNative and document.getElementById "cocosLoading"
      document.body.removeChild(document.getElementById "cocosLoading")

    cc.view.enableRetina off
    cc.view.adjustViewPort on

    if cc.sys.isNative
      searchPaths = jsb.fileUtils.getSearchPaths()
      searchPaths.push 'script'
      if cc.sys.os is cc.sys.OS_IOS or  cc.sys.os == cc.sys.OS_OSX
        searchPaths.push "res"
        searchPaths.push "src"
        searchPaths.push "bms"

      jsb.fileUtils.setSearchPaths searchPaths

    if cc.sys.isMobile or cc.sys.isNative
      #height =  cc.view.getFrameSize().height / cc.view.getFrameSize().width * 320
      #cc.view.setDesignResolutionSize 320, height, cc.ResolutionPolicy.SHOW_ALL
      cc.view.setDesignResolutionSize 320, 480, cc.ResolutionPolicy.SHOW_ALL 
      cc.view.resizeWithBrowserSize on
    else
      screenSize = window.parent.screen
      cc.view.setDesignResolutionSize screenSize.width, screenSize.height, cc.ResolutionPolicy.SHOW_ALL
      #if window.innerWidth < 800 or window.innerHeight < 600
      #  policy = new cc.ResolutionPolicy cc.ContainerStrategy.ORIGINAL_CONTAINER, cc.ContentStrategy.SHOW_ALL
      #  cc.view.setDesignResolutionSize 800, 600, cc.ContainerStrategy.ORIGINAL_CONTAINER
      cc.view.resizeWithBrowserSize off
    cc.director.setProjection cc.Director.PROJECTION_2D
    cc.director.setContentScaleFactor 2

    cc.LoaderScene.preload resList, ->
      cc.director.runScene new MenuScene()
    , this


