AppScene = require './app'
Parser   = require './parser'
res      = require './resource'
  .resObjs

MenuLayer = cc.Layer.extend
  ctor : ->
    @_super()

  start : ->
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

  _onTouch : (touch, event)->
    target = event.getCurrentTarget()
    locationInNode = target.convertToNodeSpace touch.getLocation()
    s = target.getContentSize()
    rect = cc.rect 0, 0, s.width, s.height
    if cc.rectContainsPoint rect, locationInNode
        cc.loader.loadTxt './bms/va.bms', (err, text)->
          unless err?
            parser = new Parser()
            bms = parser.parse text
            resources = []
            resources.push './bms/' + v for k, v of bms.wav
            cc.log resources
            cc.LoaderScene.preload resources, ->
              cc.director.runScene new AppScene bms, './bms/'
            , this


MenuScene = cc.Scene.extend
  ctor : ->
    @_super()
    layer = new MenuLayer()
    @addChild layer
    layer.start()

module.exports = MenuScene
