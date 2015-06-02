AppScene = require './app'
Parser   = require './parser'
res      = require './resource'
  .resObjs

menuList = [
  {url : './bms/va.bms'}
  {url : './bms/va.bms'}
  {url : './bms/va.bms'}
  {url : './bms/va.bms'}
  {url : './bms/va.bms'}
  {url : './bms/va.bms'}
  {url : './bms/va.bms'}
  {url : './bms/va.bms'}
  {url : './bms/va.bms'}
  {url : './bms/va.bms'}
  {url : './bms/va.bms'}
  {url : './bms/va.bms'}
  {url : './bms/va.bms'}
  {url : './bms/va.bms'}
  {url : './bms/va.bms'}
  {url : './bms/va.bms'}
  {url : './bms/va.bms'}
  {url : './bms/va.bms'}
  {url : './bms/va.bms'}
  {url : './bms/va.bms'}
]

MenuBaseLayer = cc.Layer.extend
  ctor : ->
    @_super()

  start : ->
    @_addBackground()

    toucheventListener = cc.EventListener.create
      event: cc.EventListener.TOUCH_ONE_BY_ONE
      swallowTouches: true
      onTouchBegan: @_onTouch.bind this

    button = new cc.Sprite res.buttonImage
    button.attr
      x : cc.director.getWinSize().width / 2
      y : cc.director.getWinSize().height / 2
    @addChild button
    cc.eventManager.addListener toucheventListener.clone(), button
    menu = new MenuController()

    menu.init menuList, cc.director.getWinSize().width / 2, 50
    @addChild menu

  _addBackground : ->
    bg = new cc.Sprite res.bgImage
    bg.x = cc.director.getWinSize().width / 2
    bg.y = cc.director.getWinSize().height / 2
    @addChild bg, 0

  _onTouch : (touch, event)->
    target = event.getCurrentTarget()
    locationInNode = target.convertToNodeSpace touch.getLocation()
    s = target.getContentSize()
    rect = cc.rect 0, 0, s.width, s.height
    if cc.rectContainsPoint rect, locationInNode
      uri = './bms/va.bms'
      prefix = @_getPrefix uri
      cc.log prefix
      cc.loader.loadTxt uri, (err, text)->
        unless err?
          parser = new Parser()
          bms = parser.parse text
          resources = []
          resources.push prefix + v for k, v of bms.wav
          cc.log resources
          cc.LoaderScene.preload resources, ->
            cc.director.runScene new AppScene bms, prefix
          , this

MenuController = cc.Layer.extend
  ctor : ->
    @_super()
    @_offsetY = 0

  init : (list, x, linespace) ->
    #var closeItem = new cc.MenuItemImage(s_pathClose, s_pathClose, this.onCloseCallback, this);
    #closeItem.x = winSize.width - 30;
    #closeItem.y = winSize.height - 30;
    director = cc.director
    size = director.getWinSize()
    @_itemMenu = new cc.Menu()

    for i in [0...list.length]
      label = new cc.LabelTTF "hoge" + i, "Arial", 24
      menuItem = new cc.MenuItemLabel label, @_onMenuCallback, this
      @_itemMenu.addChild menuItem, i + 10000
      menuItem.x = x
      menuItem.y = size.height - (i + 1) * linespace

    @_itemMenu.width = size.width
    @_itemMenu.height = (list.length + 1) * linespace
    @_itemMenu.x = 0
    if @_itemMenu.height < size.height
      @_itemMenu.y = (@_itemMenu.height - size.height) / 2
    else
      @_itemMenu.y = 0
    @addChild @_itemMenu

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

  _moveMenu : (delta) ->
    newY = @_itemMenu.y + delta.y
    size = cc.director.getWinSize()
    if @_itemMenu.height < size.height
      newY = (@_itemMenu.height - size.height) / 2
    else
      if newY < 0
        newY = 0
      else if newY > @_itemMenu.height - size.height
        newY = @_itemMenu.height - size.height
    @_itemMenu.y = newY

  _getPrefix : (url)->
      m = /^.+\//.exec url
      m[0] if m

  _onMenuCallback : (sender) ->
    @_offsetY = @_itemMenu.y
    # get id
    id = sender.getLocalZOrder() - 10000
    # get the userdata, it's the index of the menu item clicked
    # create the test scene and run it
    cc.log "touch menu id = #{id}"
    url = menuList[id].url
    prefix = @_getPrefix url
    cc.log prefix
    cc.loader.loadTxt url, (err, text)->
      unless err?
        parser = new Parser()
        bms = parser.parse text
        resources = []
        resources.push prefix + v for k, v of bms.wav
        cc.log resources
        cc.LoaderScene.preload resources, ->
          cc.director.runScene new AppScene bms, prefix
        , this

MenuScene = cc.Scene.extend
  ctor : ->
    @_super()
    layer = new MenuBaseLayer()
    @addChild layer
    layer.start()

module.exports = MenuScene
