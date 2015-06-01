JudgementLayer = cc.Layer.extend
  ctor: (@_skin) ->
    @_super()

  init : ->
    @_judgement = new cc.Sprite @_skin.judge.src, cc.rect 0, 0, @_skin.judge.width, @_skin.judge.height
    @_judgement.x = @_skin.judge.x
    @_judgement.y = @_skin.judge.y
    @_judgement.setOpacity 0
    @addChild @_judgement

  #
  # frame =
  #  0 : great
  #  1 : good
  #  2 : bad
  #  3 : poor
  # 
  show : (frame, combo, time_sec) ->
    @_judgement.setTextureRect cc.rect  0, @_skin.judge.height * frame, @_skin.judge.width, @_skin.judge.height
    @_judgement.stopAllActions()
    @_judgement.setOpacity 255
    @_judgement.runAction cc.fadeOut time_sec

module.exports = JudgementLayer
