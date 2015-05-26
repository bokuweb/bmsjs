$                 = require 'jquery'
MeasureNodesLayer = require './measureNodesLayer'
NotesLayer        = require './notesLayer'
Timer             = require './timer'
Parser            = require './parser'
Audio             = require './audio'
res               = require './resource'
  .res

skin =
  fallObj :
    fallDist : 400
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
    @_addKey()
    @_measureNodesLayer = new MeasureNodesLayer @_timer
    @addChild @_measureNodesLayer

    $.ajax
      url: 'http://localhost:8000/bms/va.bms'
      success: (bms) =>
        parser = new Parser()
        @_bms = parser.parse bms
        cc.log @_bms
        genTime = @_measureNodesLayer.init skin.fallObj, @_bms
        @_audio = new Audio @_timer, @_bms.bgms
        @_audio.init @_bms.wav, 'bms/'

        # TODO : move t oarg
        config =
          reactionTime : 200
          removeTime : 200
          judge :
            pgreat : 10
            great  : 50
            good   : 100
            bad    : 150
            poor   : 200
        @_notesLayer = new NotesLayer skin, @_timer, config
        @_notesLayer.init @_bms, genTime
        @_notesLayer.addListener 'hit', @_onHit.bind this
        @_notesLayer.addListener 'judge', @_onJudge.bind this
        @addChild @_notesLayer
        @start()

  start : ->
    @_measureNodesLayer.start()
    @_notesLayer.start on
    @_timer.start()

  _onHit : (name, wavId)->
    @_audio.play wavId

  _onJudge : (name, judgement)->
    cc.log judgement

  _addKey : ->
    toucheventListener = cc.EventListener.create
      event: cc.EventListener.TOUCH_ONE_BY_ONE
      swallowTouches: true
      onTouchBegan: @_onTouch.bind @

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
      cc.eventManager.addListener toucheventListener.clone(), key
    return
    
  _onTouch : (touch, event)->
    time = @_timer.get()
    target = event.getCurrentTarget()
    locationInNode = target.convertToNodeSpace touch.getLocation()
    s = target.getContentSize()
    rect = cc.rect 0, 0, s.width, s.height
    if cc.rectContainsPoint rect, locationInNode
      cc.log "id = #{target.id} time = #{time}"
      @_notesLayer.onTouch target.id, time
      return true
    return false

AppScene = cc.Scene.extend
  onEnter:->
    @_super()
    layer = new AppLayer()
    @addChild layer

module.exports = AppScene
