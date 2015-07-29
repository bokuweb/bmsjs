Audio = cc.Layer.extend

  ctor : (@_timer, @_bgms)->
    @_super()
    @_wav = []
    @_index = 0
    @_audio = cc.audioEngine

  init : (res, prefix)->
    @_wav[k] = prefix + v for k, v of res

  play : (id)->
    @_audio.playEffect @_wav[id], false

  startBgm : ->
    @scheduleUpdate()

  stopBgm : ->

  update : ->
    time = @_timer.get()
    while time >= @_bgms[@_index]?.timing
      @play @_bgms[@_index].id
      @_index++

  onExit : ->
    @_super()
    @removeAllChildren on
    for wav in @_wav when wav?
      cc.audioEngine.unloadEffect wav 
      console.log wav
    @_wav = []
    
module.exports = Audio
