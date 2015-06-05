EnchantAudio = cc.Layer.extend
  ctor : ( @_timer, @_bgms)->
    @_super()
    @_wav = []

  init : (res, prefix)->
    @_index = 0
    @_wav[k] = cc.enchant.assets[prefix + v] for k, v of res
    true

  play : (id)->
    @_wav[id].play true

  startBgm : -> @scheduleUpdate()

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
