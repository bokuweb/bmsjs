AppScene      = require './app'
Parser        = require './parser'
SearchLayer   = require './searchLayer'
LevelFont     = require './numeralLayer'
res           = require './resource'
  .resObjs

# TODO : cson化
# jsbで読む場合ファイルはutf-8の*.txtである必要がある
# txtはresディレクトリの下に配置する必要あり
menuList = [
  {url : "bms/dq.bms", title : 'DRAGON QUEST V', artist : 'mattaku'}
  {url : 'bms/7_n_ka08_lt.bms', title : '日溜りの街−あ！−[Light]'}  
  {url : 'bms/7_n_ka08_bt7god.bms', title : '日溜りの街−あ！−(GOD)'}
  {url : 'bms/7_n_ka08_bt8master.bms', title : '日溜りの街−あ！−(BMS MASTER)'}
  {url : 'bms/va.bms', title : 'V(SOFT LANDING PARADISE)'}
  {url : "bms/dq.bms", title : 'DRAGON QUEST V', artist : 'mattaku'}
  {url : 'bms/7_n_ka08_lt.bms', title : '日溜りの街−あ！−[Light]'}  
  {url : 'bms/7_n_ka08_bt7god.bms', title : '日溜りの街−あ！−(GOD)'}
  {url : 'bms/7_n_ka08_bt8master.bms', title : '日溜りの街−あ！−(BMS MASTER)'}
  {url : 'bms/va.bms', title : 'V(SOFT LANDING PARADISE)'}  
]


MenuBaseLayer = cc.Layer.extend
  ctor : ->
    @_super()

  start : ->
    @_addBackground()
    menu = new MenuController()
    menu.init menuList, cc.director.getWinSize().width / 2 + 150, 70
    @addChild menu

  onExit : ->
    @_super()
    @removeAllChildren on

  _addBackground : ->
    bg = new cc.Sprite res.menuBgImage
    bg.x = cc.director.getWinSize().width / 2
    bg.y = cc.director.getWinSize().height / 2
    @addChild bg, 0

MenuController = cc.Layer.extend
  ctor : ->
    @_super()
    @_offsetY = 0

  init : (list, x, @_linespace) ->
    director = cc.director
    size = director.getWinSize()
    @_itemMenu = new cc.Menu()
    for v, i in list

      item = new cc.Sprite res.itemBgImage
      label = new cc.LabelTTF v.title, "Arial", 22, cc.size(item.width, 0), cc.TEXT_ALIGNMENT_LEFT
      label.x = 320
      label.y = 38
      item.addChild label

      level = new LevelFont
        src    : res.levelFontImage
        width  : 26.2
        height : 16
        scale  : 1
        margin : 0
      level.x = 30
      level.y = 39
      
      item.addChild level
      level.init 2, 19
      menuItem = new cc.MenuItemSprite item, null, null, @_onMenuCallback, this
      @_itemMenu.addChild menuItem, i + 10000
      menuItem.x = x
      menuItem.y = size.height - (i + 1) * @_linespace
      menuItem.title = v.title

    @_itemMenu.width = size.width
    @_itemMenu.height = (list.length + 1) * @_linespace
    @_itemMenu.x = 0
    if @_itemMenu.height < size.height
      @_itemMenu.y = (@_itemMenu.height - size.height) / 2
    else
      @_itemMenu.y = 0
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
    url = menuList[id].url
    prefix = @_getPrefix url
    cc.log url

    if cc.sys.isNative
      text = jsb.fileUtils.getStringFromFile url
      cc.log jsb.fileUtils.fullPathForFilename url
      cc.log jsb.fileUtils.isFileExist url
      parser = new Parser()
      bms = parser.parse text
      resources = []
      for k, v of bms.wav
        resources.push prefix + v 
      cc.LoaderScene.preload resources, ->
        cc.director.runScene new AppScene bms, prefix
      , this
    else
      cc.loader.loadTxt url, (err, text) =>
        parser = new Parser()
        bms = parser.parse text
        resources = []
        for k, v of bms.wav
          resources.push prefix + v 
        cc.LoaderScene.preload resources, ->
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
          cc.moveTo 0.2, cc.p(size.width / 2 + 150, destY)
        )
      )

    @_itemMenu.height = (visibleItems.length + 1) * @_linespace
    if @_itemMenu.height < size.height
      @_itemMenu.y = (@_itemMenu.height - size.height) / 2
    else
      @_itemMenu.y = 0


MenuScene = cc.Scene.extend
  ctor : ->
    @_super()
    layer = new MenuBaseLayer()
    @addChild layer
    layer.start()

  onExit : ->
    @_super()
    @removeAllChildren on

module.exports = MenuScene
