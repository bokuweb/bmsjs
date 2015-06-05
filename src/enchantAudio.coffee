EnchantAudio = cc.Layer.extend
  _wav : []
  _index : 0
  _scheduleId : null

  ctor : ( @_timer, @_bgms)->

  init : (res, prefix)->
    @_index = 0
    @_wav[k] = cc.enchant.assets[prefix + v] for k, v of res

  play : (id)->
    @_wav[id].play true

  startBgm : ->
    @scheduleUpdate()

  hasAllBgmPlayEnd : ->
    for k, v of @_wav when v.currentTime < v.duration
      return false
    return true

  update : ->
    time = @_timer.get()
    while time >= @_bgms[@_index]?.timing
      @play @_bgms[@_index].id
      @_index++

module.exports = EnchantAudio
