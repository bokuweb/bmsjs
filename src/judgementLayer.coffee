JudgementLayer = cc.Layer.extend
  ctor: (@_skin) ->
    @_super()

  init : ->
    @_judgement = new cc.Sprite @_skin.src, cc.rect 0, 0, @_skin.width, @_skin.height
    @_judgement.x = cc.screenSize.width / 2  + @_skin.x
    @_judgement.y = cc.screenSize.height - @_skin.y
    @_judgement.setOpacity 0
    @addChild @_judgement

  #
  # frame =
  #  0 : pgreat
  #  1 : grear
  #  2 : good
  #  3 : bad
  #  4 : poor
  # 
  show : (frame, combo, time_sec) ->
    @_judgement.setTextureRect cc.rect  0, @_skin.height * frame, @_skin.width, @_skin.height
    @_judgement.stopAllActions()
    @_judgement.setOpacity 255
    @_judgement.runAction cc.fadeOut time_sec

module.exports = JudgementLayer
