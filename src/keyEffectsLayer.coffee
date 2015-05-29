KeyEffectsLayer = cc.Layer.extend
  ctor : (@_skin)->
    @_super()
    @_effects = []

  init : (xList)->
    @_effects.length = 0
    for x, i in xList
      switch i
        when 0, 2, 4, 6 then @_effects[i] = new cc.Sprite @_skin.whiteKeydownImage.src
        when 1, 3, 5    then @_effects[i] = new cc.Sprite @_skin.blackKeydownImage.src
        when 7          then @_effects[i] = new cc.Sprite @_skin.turntableKeydownImage.src
        else throw new Error "error unlnown note"
      @_effects[i].x = x
      console.log @_skin.y
      @_effects[i].y = @_skin.y
      @_effects[i].setAnchorPoint cc.p(0.5,0)
      @addChild @_effects[i]
      @_effects[i].setOpacity 0
    return

  show : (id, time)->
    @_effects[id].setOpacity 255
    @_effects[id].runAction cc.fadeOut time

module.exports = KeyEffectsLayer
