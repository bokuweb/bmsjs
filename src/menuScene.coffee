AppScene      = require './app'
Parser        = require './parser'
SearchLayer   = require './searchLayer'
res           = require './resource'
  .resObjs

# TODO : cson化
# ファイルはutf-8の*.txtである必要がある
# txtはresディレクトリの下に配置する必要あり
menuList = [
  {url : "res/bms/va2.txt", title : 'v_soflan0'}
  {url : "res/bms/dq.txt", title : 'DRAGON QUEST V', artist : 'mattaku'}
  {url : 'bms/7_n_ka08_bt7god.txt', title : '7_n_ka08_bt7god'}
  {url : 'bms/7_n_ka08_bt8master.txt', title : '7_n_ka08_btmaster'}
  {url : 'bms/va.txt', title : 'テスト'}
  {url : './bms/va.bms', title : 'あいうえお'}
  {url : './bms/va.txt', title : 'v_soflan7'}
  {url : './bms/va.bms', title : 'v_soflan8'}
  {url : './bms/va.bms', title : 'v_soflan9'}
  {url : './bms/va.bms', title : 'v_soflan10'}
  {url : './bms/va.bms', title : 'v_soflan11'}
  {url : './bms/va.bms', title : 'v_soflan12'}
  {url : './bms/va.bms', title : 'v_soflan13'}
  {url : './bms/va.bms', title : 'v_soflan14'}
  {url : './bms/va.bms', title : 'bar'}
  {url : './bms/va.bms', title : 'foo'}
  {url : './bms/va.bms', title : 'fuga'}
  {url : './bms/va.bms', title : 'fugafuga'}
  {url : './bms/va.bms', title : 'hoge'}
]


MenuBaseLayer = cc.Layer.extend
  ctor : ->
    @_super()

  start : ->
    @_addBackground()
    menu = new MenuController()
    menu.init menuList, cc.director.getWinSize().width / 2, 50
    @addChild menu

  onExit : ->
    @_super()
    @removeAllChildren on

  _addBackground : ->
    bg = new cc.Sprite res.bgImage
    bg.x = cc.director.getWinSize().width / 2
    bg.y = cc.director.getWinSize().height / 2
    @addChild bg, 0

MenuController = cc.Layer.extend
  ctor : ->
    @_super()
    @_offsetY = 0

  init : (list, x, @_linespace) ->
    #var closeItem = new cc.MenuItemImage(s_pathClose, s_pathClose, this.onCloseCallback, this);
    #closeItem.x = winSize.width - 30;
    #closeItem.y = winSize.height - 30;
    director = cc.director
    size = director.getWinSize()
    @_itemMenu = new cc.Menu()
    for v, i in list
      label = new cc.LabelTTF v.title, "Arial", 24
      menuItem = new cc.MenuItemLabel label, @_onMenuCallback, this
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
      cc.log text
      cc.log url
      cc.log jsb.fileUtils.fullPathForFilename url
      cc.log jsb.fileUtils.isFileExist url
      parser = new Parser()
      bms = parser.parse text
      resources = []
      for k, v of bms.wav
        resources.push prefix + v 
        cc.log v
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
          cc.log v
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
          cc.moveTo 0.2, cc.p(size.width / 2, destY)
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
