EventObserver    = require './eventObserver'
SearchController = require './searchController'

SearchLayer = cc.Layer.extend
  ctor : ->
    @_super()
    @_notifier = new EventObserver()

  init : (searchItems) ->
    @_oldTxt = null
    @_searchController = new SearchController searchItems

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

  addListener: (name, listner)->
    @_notifier.on name, listner

  start : -> @scheduleUpdate()

  update : ->
    txt = @_textField.getContentText()
    if @_oldTxt isnt txt
      @_oldTxt = txt
      @_notifier.trigger 'change', @_searchController.search(txt)

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

module.exports = SearchLayer
