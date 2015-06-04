LoaderScene = cc.LoaderScene.extend
  init : ->
    @_bgLayer = new cc.LayerColor cc.color(0, 0, 0, 255)
    @addChild @_bgLayer, 0

    @_label = new cc.LabelTTF "Loading... 0%", "Arial", 16
    @_label.x = cc.director.getWinSize().width / 2
    @_label.y = cc.director.getWinSize().height / 2
    @_label.setColor cc.color(255, 255, 255)
    @_bgLayer.addChild @_label, 10

  _initStage : (img, centerPos) ->
    #@_super img, centerPos

  onEnter : ->
    @_super()

  onExit : ->
    @_super()

  initWithResources : (resources, cb, target) ->
    @_super resources, cb, target

  _startLoading : ->
    @_super()

LoaderScene.preload = (resources, cb, target) ->
  _cc = cc
  if not _cc.loaderScene
    _cc.loaderScene = new LoaderScene()
    _cc.loaderScene.init()

  _cc.loaderScene.initWithResources resources, cb, target
  cc.director.runScene _cc.loaderScene
  _cc.loaderScene

module.exports = LoaderScene
