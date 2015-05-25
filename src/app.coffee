$                 = require 'jquery'
MeasureNodesLayer = require './measureNodesLayer'
Timer             = require './timer'
Parser            = require './parser'
res               = require './resource'
  .res

skin =
  nodeImage :
    src : res.nodeImage
  fallDist :  300

AppLayer = cc.Layer.extend

  ctor : ->
    @_super()
    @_timer = new Timer()
    @_measureNodesLayer = new MeasureNodesLayer @_timer
    @init()

  init : ->
    @_addKey()

    nodes = [
      {timing : 2}
      {timing : 4}
      {timing : 6}
    ]

    bpms = [
      {val : 120, timing : 0}
    ]


    @addChild @_measureNodesLayer
    @_measureNodesLayer.init skin, bpms, nodes

    $.ajax
      url: 'http://localhost:8000/bms/va.bms'
      success: (bms) =>
        parser = new Parser()
        @_bms = parser.parse bms
        cc.log @_bms


  start : ->
    @_timer.start()
    @_measureNodesLayer.start()

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
