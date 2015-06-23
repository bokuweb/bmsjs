KeyboardService = require './keyboardService'
NotesLayer      = require './notesLayer'
RateLayer       = require './rateLayer'
StatsLayer      = require './statsLayer'
BpmLayer        = require './bpmLayer'
PlaytimeLayer   = require './playtimeLayer'
Timer           = require './timer'
Audio           = require './audio'
GameoverScene   = require './gameoverScene'
res             = require './resource'
  .resObjs

unless cc.sys.isNative
  screenSize = window.parent.screen

# TODO : move
skin =
  body :
    bgImage :
      src : res.bgImage
    turntable :
      src : res.turntableImage
      x : screenSize.width / 2 - 274
      y : screenSize.height - 348
      z : 10
  notes :
    fallDist : 320
    keyNum   : 8
    offsetX  : screenSize.width / 2 - 266
    marginX  : 1.95
    z        : 4
    nodeImage :
      src    : res.nodeImage
      width  : 194
      height : 1
      x      : screenSize.width / 2 - 190
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
      x   : screenSize.width / 2 - 190
      y   : screenSize.height - 320
    greatEffect :
      src    : res.greatEffectImage
      width  : 80
      height : 80
      row    : 6
      colum  : 3
      delay  : 0.02
      z      : 5
    keyEffect :
      y : screenSize.height - 320
      turntableKeydownImage :
        src : res.turntableKeydownImage
      whiteKeydownImage :
        src : res.whiteKeydownImage
      blackKeydownImage :
        src : res.blackKeydownImage

  rate :
    z : 10
    meter :
      src    : res.meterImage
      width  : 4
      height : 12
      x      : screenSize.width / 2 - 292
      y      : screenSize.height - 386
      z      : 10
    label :
      src    : res.numeralImage
      width  : 26.2
      height : 16
      scale  : 0.5
      margin : 0
      x : screenSize.width / 2 - 68
      y : screenSize.height - 384
  stats :
    z : 10
    judge :
      src    : './res/judge-image.png'
      width  : 153
      height : 38.8
      x : screenSize.width / 2 - 188
      y : screenSize.height - 260
    score :
      src    : res.numeralImage
      width  : 26.2
      height : 16
      scale  : 0.8
      margin : 0
      x : screenSize.width / 2 - 122
      y : screenSize.height - 429
    pgreatNum :
      src    : res.numeralImage
      width  : 26.2
      height : 16
      scale  : 0.5
      margin : 0
      x : screenSize.width / 2 + 18
      y : screenSize.height - 415
    greatNum :
      src    : res.numeralImage
      width  : 26.2
      height : 16
      scale  : 0.5
      margin : 0
      x : screenSize.width / 2 + 18
      y : screenSize.height - 428
    goodNum :
      src    : res.numeralImage
      width  : 26.2
      height : 16
      scale  : 0.5
      margin : 0
      x : screenSize.width / 2 + 18
      y : screenSize.height - 439
    badNum :
      src    : res.numeralImage
      width  : 26.2
      height : 16
      scale  : 0.5
      margin : 0
      x : screenSize.width / 2 + 18
      y : screenSize.height - 451
    poorNum :
      src    : res.numeralImage
      width  : 26.2
      height : 16
      scale  : 0.5
      margin : 0
      x : screenSize.width / 2 + 18
      y : screenSize.height - 462
    comboNum :
      src    : res.numeralImage
      width  : 26.2
      height : 16
      scale  : 0.8
      margin : 0
      x : screenSize.width / 2 - 102
      y : screenSize.height - 451
  bpm :
    src    : res.numeralImage
    width  : 26.2
    height : 16
    scale  : 0.7
    margin : 0
    x : screenSize.width / 2 + 74
    y : screenSize.height - 450
    z : 10
  playtime :
    src    : res.numeralImage
    width  : 26.2
    height : 16
    scale  : 0.6
    margin : 0
    z : 10
    minuite :
      x : screenSize.width / 2 + 39
      y : screenSize.height - 393
    second :
      x : screenSize.width / 2 + 73
      y : screenSize.height - 393

AppLayer = cc.Layer.extend
  ctor : (@_bms, prefix)->
    @_super()
    @_timer = new Timer()
    #@_addKey()

    @_addBackground()
    @_audio = new Audio @_timer, @_bms.bgms
    @_audio.init @_bms.wav, prefix
    @addChild @_audio

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
    @_keyboard.addListener v, @_onKeydown.bind this, id for v, id in keyConfig
    @addChild @_keyboard

    # FIXME : move to argument
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
    #@_notesLayer.addListener 'end', @_onEnd.bind this

    @addChild @_notesLayer, skin.notes.z


    @_rate = new RateLayer skin.rate
    @_rate.init
      # FIXME : move to argument
      initRate    : 20
      greatIncVal : 1
      goodIncVal  : 0.5
      badDecVal   : -0.4
      poorDecVal  : -0.4
      num         : 50
      clearVal    : 40
    @addChild @_rate, skin.rate.z

    @_stats = new StatsLayer skin.stats
    @_stats.init @_bms.totalNote, 200000
    @addChild @_stats, skin.stats.z

    @_bpm = new BpmLayer skin.bpm, @_timer, @_bms.bpms
    @_bpm.init()
    @addChild @_bpm, skin.bpm.z
    @_playtime = new PlaytimeLayer skin.playtime, @_timer
    @_playtime.init()
    @addChild @_playtime, skin.playtime.z

    cc.log @_bms.animations.length
    if @_bms.animations.length is 0
      soundonly = new cc.LabelTTF "Sound Only", "sapceage" , 32
      #soundonly = new cc.Sprite res.soundonlyImage
      soundonly.x = screenSize.width / 2 + 100
      soundonly.y = screenSize.height - 200
      soundonly.setOpacity 200
      @addChild soundonly, 100

  start : ->
    @_notesLayer.start off
    @_audio.startBgm()
    @_rate.start()
    @_bpm.start()
    @_playtime.start()
    @_timer.start()
    @scheduleUpdate()

  update : ->
    if @_timer.get() > @_bms.endTime + 5000
      @unscheduleUpdate()
      @_timer.stop()
      cc.director.runScene new cc.TransitionFade(1.2, new GameoverScene(@_stats.get()))

  onExit : ->
    @_super()
    @removeAllChildren on

  _onKeydown : (id, key, time) ->
    @_notesLayer.onTouch id, time

  _onHit : (event, wavId) ->
    @_audio.play wavId

  _onEnd : (event) ->
    @scheduleOnce @_changeSceneToGameOver, 5

  _onJudge : (event, judge) ->
    #cc.log judge
    @_rate.reflect judge
    @_stats.reflect judge

  _addBackground : ->
    bg = new cc.Sprite res.bgImage
    bg.x = cc.director.getWinSize().width / 2
    bg.y = cc.director.getWinSize().height / 2
    @addChild bg, 0

    # test image
    bg = new cc.Sprite "res/test.png"
    bg.x = cc.director.getWinSize().width / 2
    bg.y = cc.director.getWinSize().height - 240
    @addChild bg, 1

    turntable = new cc.Sprite res.turntableImage
    turntable.x = skin.body.turntable.x
    turntable.y = skin.body.turntable.y
    turntable.setOpacity 200
    @addChild turntable, skin.body.turntable.z
    turntable.runAction new cc.RepeatForever new cc.RotateBy(5, 360)

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

#window.onblur = ->
#  window.stop();


AppScene = cc.Scene.extend

  ctor : (bms, prefix)->
    @_super()
    layer = new AppLayer bms, prefix
    @addChild layer
    layer.start()

  onExit : -> @removeAllChildren on
  
module.exports = AppScene
