$                 = require 'jquery'
MeasureNodesLayer = require './measureNodesLayer'
NotesLayer        = require './notesLayer'
Timer             = require './timer'
Parser            = require './parser'
res               = require './resource'
  .res

skin =
  fallObj :
    fallDist : 300
    keyNum : 8
    offset : 35
    margin : 2
    zIndex : 4
    nodeImage :
      type : "image"
      src : res.nodeImage
      width : 194
      height : 1
      x : 0
      y : -10
      z : 1
    noteTurntableImage :
      type : "image"
      src : res.notetuntableImage
      width : 41
      height : 6
      x : 0
      y : -10
      z : 1
    noteWhiteImage :
      type : "image"
      src : res.noteWhiteImage
      width : 22
      height : 6
      x : 0
      y : -10
      z : 1
    noteBlackImage :
      type : "image"
      src : res.noteBlackImage
      width : 17
      height : 6
      x : 0
      y : -10
      z : 1


AppLayer = cc.Layer.extend

  ctor : ->
    @_super()
    @_timer = new Timer()
    @init()

  init : ->
    #@_addKey()
    @_measureNodesLayer = new MeasureNodesLayer @_timer
    @addChild @_measureNodesLayer

    $.ajax
      url: 'http://localhost:8000/bms/va.bms'
      success: (bms) =>
        parser = new Parser()
        @_bms = parser.parse bms
        cc.log @_bms
        genTime = @_measureNodesLayer.init skin.fallObj, @_bms.bpms, @_bms.data
        cc.log genTime
        config =
          reaction   : 200
          removeTime : 200
          judge :
            pgreat : 10
            great  : 50
            good   : 100
            bad    : 150
            poor   : 200
        @_notesLayer = new NotesLayer skin, @_timer, config
        @_notesLayer.init @_bms, genTime
        @addChild @_notesLayer
        @start()

  start : ->
    @_measureNodesLayer.start()
    @_notesLayer.start()
    @_timer.start()

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
