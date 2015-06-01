KeyboardService   = require './keyboardService'
NotesLayer        = require './notesLayer'
RateLayer         = require './rateLayer'
Timer             = require './timer'
Audio             = require './audio'
res               = require './resource'
  .resObjs

# TODO : move
skin =
  body :
    bgImage :
      src : res.bgImage
  notes :
    fallDist : 320
    keyNum   : 8
    offsetX  : 134
    marginX  : 1.95
    z        : 4
    nodeImage :
      src    : res.nodeImage
      width  : 194
      height : 1
      x      : 210
    noteTurntableImage :
      src    : res.noteTurntableImage
      width  : 41
      height : 6
    noteWhiteImage :
      src    : res.noteWhiteImage
      width  : 22
      height : 6
    noteBlackImage :
      src    : res.noteBlackImage
      width  : 17
      height : 6
    bgImage :
      src : res.noteBgImage
      x   : 210
      y   : 280
    greatEffect :
      src    : res.greatEffectImage
      width  : 80
      height : 80
      row    : 6
      colum  : 3
      delay  : 0.02
      z      : 5
    keyEffect :
      y : 280
      turntableKeydownImage :
        src : res.turntableKeydownImage
      whiteKeydownImage :
        src : res.whiteKeydownImage
      blackKeydownImage :
        src : res.blackKeydownImage
  rate :
    z : 10
    meter :
      src    : "./res/gauge.png"
      width  : 4
      height : 12
      x      : 126
      y      : 206
      z      : 10
    label :
      src    :  './res/numeral-font.png'
      width  : 8
      height : 8
      scale  : 2
      x : 0
      y : 0

AppLayer = cc.Layer.extend
  ctor : (@_bms, prefix)->
    @_super()
    @_timer = new Timer()
    #@_addKey()
    @_addBackground()
    @_audio = new Audio @_timer, @_bms.bgms
    @_audio.init @_bms.wav, prefix
    @_keyboard = new KeyboardService @_timer

    # FIXME : move to argument
    keyConfig = [
      'Z'.charCodeAt(0)
      'S'.charCodeAt(0)
      'X'.charCodeAt(0)
      'D'.charCodeAt(0)
      'C'.charCodeAt(0)
      'F'.charCodeAt(0)
      'V'.charCodeAt(0)
      16
    ]

    @_keyboard.init()
    @_keyboard.addListener v, @_onKeydown, id for v, id in keyConfig
    @addChild @_keyboard

    config =
      reactionTime : 200
      removeTime : 200
      judge :
        pgreat : 10
        great  : 50
        good   : 100
        bad    : 150
        poor   : 200

    @_notesLayer = new NotesLayer skin.notes, @_timer, config
    @_notesLayer.init @_bms
    @_notesLayer.addListener 'hit', @_onHit.bind this
    @_notesLayer.addListener 'judge', @_onJudge.bind this

    @addChild @_notesLayer, skin.notes.z
    @addChild @_audio

    @_rate = new RateLayer skin.rate
    @_rate.init
      initRate    : 20
      greatIncVal : 1
      goodIncVal  : 0.5
      badDecVal   : -0.4
      poorDecVal  : -0.4
      num         : 50
      clearVal    : 40
    @addChild @_rate, skin.rate.z

  start : ->
    @_notesLayer.start on
    @_audio.startBgm()
    @_rate.start()
    @_timer.start()

  _onKeydown : (key, time, id)->
    @_notesLayer.onTouch id, time

  _onHit : (event, wavId)->
    @_audio.play wavId

  _onJudge : (event, judge)->
    @_rate.reflect judge

  _addBackground : ->
    bg = new cc.Sprite res.bgImage
    bg.x = cc.director.getWinSize().width / 2
    bg.y = cc.director.getWinSize().height / 2
    @addChild bg, 0

    # test image
    ###
    bg = new cc.Sprite "res/test.png"
    bg.x = cc.director.getWinSize().width / 2
    bg.y = cc.director.getWinSize().height - 240
    @addChild bg, 1
    ###
    
  _addKey : ->
    toucheventListener = cc.EventListener.create
      event: cc.EventListener.TOUCH_ONE_BY_ONE
      swallowTouches: true
      onTouchBegan: @_onTouch.bind this

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

  ctor : (bms, prefix)->
    @_super()
    layer = new AppLayer bms, prefix
    @addChild layer
    layer.start()

module.exports = AppScene
