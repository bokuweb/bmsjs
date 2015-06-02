AppScene      = require './app'
Parser        = require './parser'
_             = require 'lodash'
EventObserver = require './eventObserver'
res           = require './resource'
  .resObjs


# TODO : cson化
menuList = [
  {url : './bms/va.bms', title : 'v_soflan0'}
  {url : './bms/va.bms', title : 'v_soflan1'}
  {url : './bms/va.bms', title : 'v_soflan2'}
  {url : './bms/va.bms', title : 'v_soflan3'}
  {url : './bms/va.bms', title : 'v_soflan4'}
  {url : './bms/va.bms', title : 'テスト'}
  {url : './bms/va.bms', title : 'あいうえお'}
  {url : './bms/va.bms', title : 'v_soflan7'}
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

    search = new SearchController()
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

  _moveMenu : (delta) ->
    newY = @_itemMenu.y + delta.y
    size = cc.director.getWinSize()
    if @_itemMenu.height < size.height
      newY = (@_itemMenu.height - size.height) / 2
    else
      if newY < 0
        @_itemMenu.y = 0
        move = cc.moveBy 0.05, 0, 20
        @_itemMenu.runAction cc.sequence(
          move
          move.reverse()
          cc.CallFunc.create ->
            @_itemMenu.y = 0
          , this
        )
      else if newY > @_itemMenu.height - size.height
        @_itemMenu.y = @_itemMenu.height - size.height
        move = cc.moveBy 0.05, 0, -20
        @_itemMenu.runAction cc.sequence(
          move
          move.reverse()
          cc.CallFunc.create ->
            @_itemMenu.y = @_itemMenu.height - size.height
          , this
        )
      else
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

  _onChanged : (name, arrayOfVisible) ->
    size = cc.director.getWinSize()
    visibleItemNum = 0 
    for v, i in arrayOfVisible
      @_itemMenu.children[i].stopAllActions()
      if v
        destY = size.height - (visibleItemNum + 1) * @_linespace
        visibleItemNum += 1
        @_itemMenu.children[i].runAction(
          cc.spawn(
            cc.fadeIn 0.2
            cc.scaleTo 0.2, 1
            cc.moveTo 0.2, cc.p(size.width / 2, destY)
          )
        )
      else
        @_itemMenu.children[i].runAction(cc.spawn(cc.fadeOut 0.2, cc.scaleTo 0.2, 0))

    @_itemMenu.height = (visibleItemNum + 1) * @_linespace
    if @_itemMenu.height < size.height
      @_itemMenu.y = (@_itemMenu.height - size.height) / 2
    else
      @_itemMenu.y = 0

SearchController = cc.Layer.extend
  ctor : ->
    @_super()
    @_notifier = new EventObserver()
    @_oldTxt = null
    if 'touches' of cc.sys.capabilities
      cc.eventManager.addListener
        event : cc.EventListener.TOUCH_ALL_AT_ONCE
        onTouchesEnded: @onTouchesEnded
      , this
    else if 'mouse' of cc.sys.capabilities
      cc.eventManager.addListener
        event : cc.EventListener.MOUSE
        onMouseUp: @_onMouseUp
      , this

    @_textField = new cc.TextFieldTTF "<search>", "Arial", 20
    @addChild @_textField
    #@_textField.setDelegate this
    size = cc.director.getWinSize()
    @_textField.x = size.width / 2 - 200
    @_textField.y = size.height / 2 + 200

  init : (@_searchItems) ->

  addListener: (name, listner)->
    @_notifier.on name, listner

  start : -> @scheduleUpdate()

  stop : -> @unscheduleUpdate()

  update : ->
    txt = @_textField.getContentText()
    if @_oldTxt isnt txt
      @_oldTxt = txt
      arrayOfVisible = []
      for item in @_searchItems
        if item.title.search(txt) is -1 and txt isnt ''
          arrayOfVisible.push off
        else
          arrayOfVisible.push on
      @_notifier.trigger 'change', arrayOfVisible 


  # CCTextFieldDelegate
  onTextFieldAttachWithIME : (sender) ->

  onTextFieldDetachWithIME : (sender) ->

  onTextFieldInsertText : (sender, text, len) ->

  onTextFieldDeleteBackward : (sender, delText, len) ->

  _textInputGetRect : (node) ->
    r = cc.rect node.x, node.y, node.width, node.height
    r.x -= r.width / 2
    r.y -= r.height / 2
    r

  _onClickTrackNode : (clicked) ->
    if clicked
      @_textField.attachWithIME()
     else
      @_textField.detachWithIME()

  _onMouseUp : (event) ->
    target = event.getCurrentTarget()
    return unless target._textField

    point = event.getLocation()
    rect = target._textInputGetRect target._textField
    target._onClickTrackNode cc.rectContainsPoint(rect, point)

MenuScene = cc.Scene.extend
  ctor : ->
    @_super()
    layer = new MenuBaseLayer()
    @addChild layer
    layer.start()

module.exports = MenuScene
