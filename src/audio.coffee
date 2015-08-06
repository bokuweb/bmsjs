Audio = cc.Layer.extend

  ctor : (@_timer, @_bgms)->
    @_super()
    @_wav = []
    @_index = 0
    @_audio = cc.audioEngine

  init : (res, prefix)->
    @_wav[k] =  (prefix + encodeURIComponent(v)) for k, v of res

  play : (id)->
    @_audio.playEffect @_wav[id], false if @_wav[id]?

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
    cc.audioEngine.stopAllEffects()
    for wav in @_wav when wav?
      cc.audioEngine.unloadEffect wav 
    @_wav = []

module.exports = Audio
