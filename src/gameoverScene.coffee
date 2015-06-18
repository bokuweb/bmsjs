res = require './resource'
  .resObjs


GameOverLayer = cc.Layer.extend
  ctor : (@_stats) ->
    @_super()
    @_addBackground()
    @_MenuScene = require './menuScene'

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

    @_stats.score ?= 0
    label = new cc.LabelTTF "", "sapceage" , 32
    label.x = cc.director.getWinSize().width / 2
    label.y = cc.director.getWinSize().height / 2 - 100
    @addChild label, 5

    label.setString """
      SCORE : #{@_stats.score}
      MAX COMBO : #{@_stats.combo}
      PGREAT : #{@_stats.pgreat}
      GREAT  : #{@_stats.great}
      GOOD   : #{@_stats.good}
      BAD    : #{@_stats.bad}
      POOR   : #{@_stats.poor}
    """

  onExit : ->
    @_super()
    @removeAllChildren on

  _addBackground : ->
    bg = new cc.Sprite res.resultBgImage
    bg.x = cc.director.getWinSize().width / 2
    bg.y = cc.director.getWinSize().height / 2
    @addChild bg, 0

  _onTouch : (touch, event)->
    target = event.getCurrentTarget()
    locationInNode = target.convertToNodeSpace touch.getLocation()
    s = target.getContentSize()
    rect = cc.rect 0, 0, s.width, s.height
    if cc.rectContainsPoint rect, locationInNode
      cc.director.runScene new cc.TransitionFade(1.2, new @_MenuScene())
      return true
    return false

  _onKeyPressed : (key, event) ->
    cc.director.runScene new cc.TransitionFade(1.2, new @_MenuScene())

GameOverScene = cc.Scene.extend

  ctor : (stats) ->
    @_super()
    layer = new GameOverLayer stats
    @addChild layer

module.exports = GameOverScene
