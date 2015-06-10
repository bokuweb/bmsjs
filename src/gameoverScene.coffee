res = require './resource'
  .resObjs

GameOverLayer = cc.Layer.extend
  ctor : ->
    @_super()
    @_addBackground()

    toucheventListener = cc.EventListener.create
      event: cc.EventListener.TOUCH_ONE_BY_ONE
      swallowTouches: true
      onTouchBegan: @_onTouch.bind this
    cc.eventManager.addListener toucheventListener, this

    if 'keyboard' of cc.sys.capabilities
      cc.eventManager.addListener
        event : cc.EventListener.KEYBOARD
        onKeyPressed : @_onKeyPressed.bind this
      , this

  onExit : ->
    @_super()
    @removeAllChildren on

  _addBackground : ->
    bg = new cc.Sprite res.bgImage
    bg.x = cc.director.getWinSize().width / 2
    bg.y = cc.director.getWinSize().height / 2
    @addChild bg, 0

  _onTouch : (touch, event)->
    MenuScene = require './menuScene'
    target = event.getCurrentTarget()
    locationInNode = target.convertToNodeSpace touch.getLocation()
    s = target.getContentSize()
    rect = cc.rect 0, 0, s.width, s.height
    if cc.rectContainsPoint rect, locationInNode
      cc.director.runScene new cc.TransitionFade(1.2, new MenuScene())
      return true
    return false

  _onKeyPressed : (key, event) ->
    MenuScene = require './menuScene'
    cc.director.runScene new cc.TransitionFade(1.2, new MenuScene())

GameOverScene = cc.Scene.extend

  ctor : (bms, prefix)->
    @_super()
    layer = new GameOverLayer()
    @addChild layer

module.exports = GameOverScene
