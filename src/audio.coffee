Audio = cc.Layer.extend
  _wav : []
  _index : 0
  _scheduleId : null

  ctor : (@_timer, @_bgms)->
    @_super()
    @_audioEngine = cc.audioEngine

  init : (res, prefix)->
    @_index = 0
    @_wav[k] = prefix + v for k, v of res

  play : (id)->
    @_audioEngine.playEffect @_wav[id], false

  startBgm : ->
    @scheduleUpdate()

  stopBgm : ->

  hasAllBgmPlayEnd : ->
    #for k, v of @_wav when v.currentTime < v.duration
    #  return false
    #return true

  update : ->
    time = @_timer.get()
    while time >= @_bgms[@_index]?.timing
      @play @_bgms[@_index].id
      @_index++

module.exports = Audio
