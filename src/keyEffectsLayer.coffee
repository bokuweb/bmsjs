KeyEffectsLayer = cc.Layer.extend
  ctor : ->
    @_super()
    @_effects = []

  init : (skin, xList)->
    @_effects.length = 0
    for x, i in xList
      switch i
        when 0, 2, 4, 6 then @_effects[i] = new cc.Sprite skin.whiteKeydownImage.src
        when 1, 3, 5    then @_effects[i] = new cc.Sprite skin.blackKeydownImage.src
        when 7          then @_effects[i] = new cc.Sprite skin.turntableKeydownImage.src
        else throw new Error "error unlnown note"
      @_effects[i].x = x
      @_effects[i].y = skin.y
      @addChild @_effects[i]
      @_effects[i].setOpacity 0
    return

  show : (id, time)->
    @_effects[id].setOpacity 255
    @_effects[id].runAction cc.fadeOut time

module.exports = KeyEffectsLayer
