AppScene      = require './app'
Parser        = require './parser'
SearchLayer   = require './searchLayer'
LevelFont     = require './numeralLayer'
res           = require './resource'
  .resObjs

MenuBaseLayer = cc.Layer.extend
  ctor : ->
    @_super()
    if window?
      window.addEventListener 'resize', ->
        screenSize = window.parent.screen
        cc.view.setDesignResolutionSize screenSize.width, screenSize.height, cc.ResolutionPolicy.SHOW_ALL

  start : ->
    if cc.sys.isMobile
      message = """
          申し訳ありません
          現在PCにのみ対応しております

      """
      pconly = new cc.LabelTTF message , "Arial" , 16
      pconly.x = cc.screenSize.width / 2
      pconly.y = cc.screenSize.height / 2
      @addChild pconly, 100
      return
    @_addBackground()
    cc.loader.loadJson cc.pathToBmsDir + 'bms.json', (error, data) =>
      menu = new MenuController data
      menu.init data, cc.director.getWinSize().width / 2 + 200, 70
      @addChild menu

  onExit : ->
    @_super()
    @removeAllChildren on

  _addBackground : ->
    bg = new cc.Sprite res.menuBgImage
    bg.x = cc.director.getWinSize().width / 2
    bg.y = cc.director.getWinSize().height / 2
    console.log "scree height #{window.parent.screen.height} bg.height = #{bg.height}"
    #if bg.height < window.parent.screen.height
    bg.scale = window.parent.screen.height / bg.height
    @addChild bg, 0

MenuController = cc.Layer.extend
  ctor : (data) ->
    @_super()
    @_offsetY = 0
    @_menuList = data

  init : (list, x, @_linespace) ->
    director = cc.director
    size = director.getWinSize()
    @_itemMenu = new cc.Menu()
    for v, i in list when v.TITLE?

      item = new cc.Sprite res.itemBgImage
      title = if v.TITLE.length > 26 then v.TITLE.substr(0, 26)+'...' else v.TITLE
      label = new cc.LabelTTF title, "Arial", 22, cc.size(item.width, 0), cc.TEXT_ALIGNMENT_LEFT
      label.x = 320
      label.y = 38
      item.addChild label

      # TODO : to cson
      level = new LevelFont
        src    : res.levelFontImage
        width  : 26.2
        height : 16
        scale  : 1
        margin : 0
      level.x = 34
      level.y = 39

      item.addChild level
      digits = if ~~(v.level / 10) > 0 then 2 else 1
      level.init digits, v.PLAYLEVEL
      menuItem = new cc.MenuItemSprite item, null, null, @_onMenuCallback, this
      @_itemMenu.addChild menuItem, i + 10000
      menuItem.x = x
      menuItem.y = size.height - (i + 1) * @_linespace
      menuItem.title = v.TITLE

    @_itemMenu.width = size.width
    @_itemMenu.height = (list.length + 1) * @_linespace
    @_itemMenu.x = 0
    @_itemMenu.y = (@_itemMenu.height - size.height) / 2
    @addChild @_itemMenu

    search = new SearchLayer()
    search.init @_itemMenu.children
    search.start()
    search.addListener 'change', @_onChanged.bind this
    @addChild search

    # 'browser' can use touches or mouse.
    # The benefit of using 'touches' in a browser, is that it works both with mouse events or touches events
    if 'touches' of cc.sys.capabilities
      cc.eventManager.addListener
        event : cc.EventListener.TOUCH_ALL_AT_ONCE
        onTouchesMoved : (touches, event) ->
          target = event.getCurrentTarget()
          delta = touches[0].getDelta()
          target._moveMenu delta
          return true
      , this
    else if 'mouse' of cc.sys.capabilities
      cc.eventManager.addListener
        event : cc.EventListener.MOUSE
        onMouseMove : (event) ->
          if event.getButton() is cc.EventMouse.BUTTON_LEFT
            event.getCurrentTarget()._moveMenu event.getDelta()
        onMouseScroll : (event) ->
          deltaY = if cc.sys.isNative then event.getScrollY() * 6 else -event.getScrollY()
          event.getCurrentTarget()._moveMenu
            y : deltaY
      , this

  onExit : ->
    @_super()
    @removeAllChildren on
  
  _moveMenu : (delta) ->
    newY = @_itemMenu.y + delta.y
    size = cc.director.getWinSize()
    if @_itemMenu.height < size.height
      newY = (@_itemMenu.height - size.height) / 2
    else
      if newY < 0
        @_itemMenu.y = 0
        move = cc.moveBy 0.05, 0, 20
      else if newY > @_itemMenu.height - size.height
        @_itemMenu.y = @_itemMenu.height - size.height
      else
        @_itemMenu.y = newY

  _getPrefix : (url)->
      m = /^.+\//.exec url
      m[0] if m

  _onMenuCallback : (sender) ->
    @_offsetY = @_itemMenu.y
    id = sender.getLocalZOrder() - 10000
    url = @_menuList[id].url
    prefix = @_getPrefix url

    cc.loader.loadTxt cc.pathToBmsDir + url, (err, text) =>
      parser = new Parser()
      bms = parser.parse text
      resources = []
      for k, v of bms.wav then resources.push (prefix + encodeURIComponent(v))
      #for k, v of bms.bmp then resources.push prefix + v

      require('./loaderScene').preload resources, ->
        cc.director.runScene new AppScene bms, prefix
      , this

  _onChanged : (name, visibleItems) ->
    size = cc.director.getWinSize()

    for item in @_itemMenu.children
      item.runAction cc.spawn cc.fadeOut(0.2), cc.scaleTo(0.2, 0)

    for item, i in visibleItems
      item.stopAllActions()
      destY = size.height - (i + 1) * @_linespace
      item.runAction(
        cc.spawn(
          cc.fadeIn 0.2
          cc.scaleTo 0.2, 1
          cc.moveTo 0.2, cc.p(size.width / 2 + 200, destY)
        )
      )

    @_itemMenu.height = (visibleItems.length + 1) * @_linespace
    @_itemMenu.y = (@_itemMenu.height - size.height) / 2

MenuScene = cc.Scene.extend
  ctor :  ->
    @_super()
    layer = new MenuBaseLayer()
    @addChild layer
    layer.start()

  onExit : ->
    @_super()
    @removeAllChildren on

module.exports = MenuScene
