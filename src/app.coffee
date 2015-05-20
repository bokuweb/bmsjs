NodesLayer = require './nodesLayer'
Timer      = require './timer'
res        = require './resource'
  .res

AppLayer = cc.Layer.extend

  ctor : ->
    @_super()
    @_timer = new Timer()
    @_nodesLayer = new NodesLayer @_timer
    @init()

  init : ->
    @_addKey()

    skin =
      nodeImage :
        src : res.nodeImage
      fallDist : 300

    nodes = [
      {timing : 2}
      {timing : 4}
      {timing : 6}
    ]

    bpms = [
      {val : 120, timing : 0}
    ]

    @addChild @_nodesLayer
    @_nodesLayer.init skin, bpms, nodes
    @_timer.start()
    @_nodesLayer.start()

  _addKey : ->
    for i in [0...8]
      key = new cc.Sprite res.buttonImage
      if i is 7
        key.attr
          x  : 33
          y  : 32
          id : 7
      else
        key.attr
          x  : i * 32 + 97
          y  : i % 2 * 64 + 32
          id : i
      @addChild key
    return

AppScene = cc.Scene.extend
  onEnter:->
    @_super()
    layer = new AppLayer()
    @addChild layer

module.exports = AppScene
