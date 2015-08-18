KeyboardService = require './keyboardService'
NotesLayer      = require './notesLayer'
RateLayer       = require './rateLayer'
StatsLayer      = require './statsLayer'
BpmLayer        = require './bpmLayer'
PlaytimeLayer   = require './playtimeLayer'
AnimeLayer      = require './animationLayer'
Timer           = require './timer'
Audio           = require './audio'
GameoverScene   = require './gameoverScene'
res             = require './resource'
  .resObjs

# TODO : move
skin =
  body :
    bgImage :
      src : res.bgImage
    turntable :
      src : res.turntableImage
      x : -274
      y : 348
      z : 10
  notes :
    fallDist : 320
    keyNum   : 8
    offsetX  : -266
    marginX  : 1.95
    z        : 4
    nodeImage :
      src    : res.nodeImage
      width  : 194
      height : 1
      x      : -190
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
      x   : -190
      y   : 320
    greatEffect :
      src    : res.greatEffectImage
      width  : 80
      height : 80
      row    : 6
      colum  : 3
      delay  : 0.02
      z      : 5
    keyEffect :
      y : 162
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
      x      : -292
      y      : 386
      z      : 10
    label :
      src    : res.numeralImage
      width  : 26.2
      height : 16
      scale  : 0.5
      margin : 0
      x : -68
      y : 384
  stats :
    z : 10
    judge :
      src    : './res/judge-image.png'
      width  : 153
      height : 38.8
      x : -188
      y : 260
    score :
      src    : res.numeralImage
      width  : 26.2
      height : 16
      scale  : 0.8
      margin : 0
      x : -122
      y : 429
    pgreatNum :
      src    : res.numeralImage
      width  : 26.2
      height : 16
      scale  : 0.5
      margin : 0
      x : 18
      y : 415
    greatNum :
      src    : res.numeralImage
      width  : 26.2
      height : 16
      scale  : 0.5
      margin : 0
      x : 18
      y : 428
    goodNum :
      src    : res.numeralImage
      width  : 26.2
      height : 16
      scale  : 0.5
      margin : 0
      x : 18
      y : 439
    badNum :
      src    : res.numeralImage
      width  : 26.2
      height : 16
      scale  : 0.5
      margin : 0
      x : 18
      y : 451
    poorNum :
      src    : res.numeralImage
      width  : 26.2
      height : 16
      scale  : 0.5
      margin : 0
      x : 18
      y : 462
    comboNum :
      src    : res.numeralImage
      width  : 26.2
      height : 16
      scale  : 0.8
      margin : 0
      x : -102
      y : 451
  bpm :
    src    : res.numeralImage
    width  : 26.2
    height : 16
    scale  : 0.6
    margin : 0
    x : 78
    y : 450
    z : 10
  playtime :
    src    : res.numeralImage
    width  : 26.2
    height : 16
    scale  : 0.6
    margin : 0
    z : 10
    minuite :
      x : 39
      y : 393
    second :
      x : 73
      y : 393
  bmp :
    x : 106
    y : 186

AppLayer = cc.Layer.extend
  ctor : (@_bms, prefix)->
    @_super()
    @_timer = new Timer()

    # TODO :
    @_stopIndex = 0

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
    @_keyboard.addListener 27, @_onEscKeydown.bind this
    @addChild @_keyboard

    # FIXME : move to argument
    config =
      reactionTime : 200
      removeTime : 200
      judge :
        pgreat : 20
        great  : 40
        good   : 105
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
      ###
      http://2nd.geocities.jp/yoshi_65c816/bms/LR2.html
      t=#TOTAL n=total notes
      ゲージの種類  PGERAT    GREAT        GOOD   POOR    BAD   空POOR
      GROOVE          t/n      t/n      (t/n)/2     -6     -4       -2
      EASY        t/n*1.2  t/n*1.2  (t/n*1.2)/2   -4.8   -3.2     -1.6
      HARD         0.1※2   0.1※2      0.05※2   -10※  -6※     -2※
      段位            0.1      0.1       0.05？     -3     -2       -2
      本家GROOVE        a        a          a/2     -6     -2       -2
      本家EASY          a        a          a/2   -4.8   -1.6     -1.6
      本家HARD       0.16     0.16            0     -9     -5        5
      本家段位       0.16     0.16         0.04   -2.5   -1.5     -1.5
      ###
      initRate    : 20
      great       : @_bms.total / @_bms.totalNote * 1.2
      good        : @_bms.total / @_bms.totalNote * 0.6
      bad         : -3.2
      poor        : -4.8
      epoor       : -1.6
      num         : 50
      clearVal    : 40
    @addChild @_rate, skin.rate.z

    @_stats = new StatsLayer skin.stats
    @_stats.init @_bms.totalNote, 
      pgreat : 150000
      great  : 100000
      good   : 20000
      combo  : 50000

    @addChild @_stats, skin.stats.z

    @_bpm = new BpmLayer skin.bpm, @_timer, @_bms.bpms
    @_bpm.init()
    @addChild @_bpm, skin.bpm.z
    @_playtime = new PlaytimeLayer skin.playtime, @_timer
    @_playtime.init()
    @addChild @_playtime, skin.playtime.z

    @_animeLayer = new AnimeLayer skin.bmp, @_timer
    console.dir @_bms.bmp
    console.dir @_bms.animations
    @_animeLayer.init @_bms.bmp, @_bms.animations, prefix
    @addChild @_animeLayer
    # FIXME
    if @_bms.animations.length is 0 or @_bms.bmp[1]?.match(/mpg$/)?
      soundonly = new cc.LabelTTF "Sound Only", "sapceage" , 32
      soundonly.x = cc.screenSize.width / 2 + 100
      soundonly.y = cc.screenSize.height - 200
      soundonly.setOpacity 200
      @addChild soundonly, 100

  start : ->
    @_notesLayer.start off
    @_audio.startBgm()
    @_rate.start()
    @_bpm.start()
    @_playtime.start()
    @_animeLayer.start()
    @_stats.start()
    @_timer.start()
    @scheduleUpdate()

  update : ->
    time = @_timer.get()

    # TODO : to class
    if @_bms.stopTiming[@_stopIndex]?
      if time >= @_bms.stopTiming[@_stopIndex].timing
        #console.log "stop id=#{@_bms.stopTiming[@_stopIndex].id}, val =#{@_bms.stop[@_bms.stopTiming[@_stopIndex].id]}"
        measureTime = 240000 / @_bpm.get()
        stopTime = @_bms.stop[@_bms.stopTiming[@_stopIndex].id] / 192 * measureTime
        console.log "stop time = #{stopTime}, bpm = #{@_bpm.get()}"
        @_timer.pause()
        @scheduleOnce ->
          @_timer.start()
        , stopTime / 1000
        @_stopIndex++

    @_exitGame() if time > @_bms.endTime + 5000

  onExit : ->
    @_super()
    @removeAllChildren on

  _exitGame : ->
    @unscheduleUpdate()
    @_timer.stop()
    cc.director.runScene new cc.TransitionFade(1.2, new GameoverScene(@_stats.get()))

  _onKeydown : (id, key, time) ->
    @_notesLayer.onTouch id, time

  _onEscKeydown : (id, key, time) ->
    # FIXME :先頭でrequireするとerror
    MenuScene =  require './menuScene'
    @unscheduleUpdate()
    @_timer.stop()
    cc.director.runScene new cc.TransitionFade(1.2, new MenuScene())

  _onHit : (event, wavId) ->
    @_audio.play wavId

  _onEnd : (event) ->
    @scheduleOnce @_changeSceneToGameOver, 5

  _onJudge : (event, judge) ->
    @_rate.reflect judge
    @_stats.reflect judge

    @_animeLayer.onPoor() if judge is 'poor' or judge is 'epoor'

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
    turntable.x = cc.screenSize.width / 2 + skin.body.turntable.x
    turntable.y = cc.screenSize.height - skin.body.turntable.y
    turntable.setOpacity 200
    @addChild turntable, skin.body.turntable.z
    turntable.runAction new cc.RepeatForever new cc.RotateBy(5, 360)

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
