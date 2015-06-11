GreatEffect = cc.Sprite.extend
  ctor : (src, params)->
    w = params.width
    h = params.height
    @_super src, cc.rect 0, 0, w, h
    animationframe = []
    num = params.row * params.colum

    for i in [0...num]
      frame = new cc.SpriteFrame src, cc.rect w * (i % params.row), h * ~~(i / params.row), w, h
      animationframe.push frame
    @_animation = new cc.Animation animationframe, params.delay
    @_animation.retain()

  run : ->
    cb = ->
      @removeFromParent on
      @_animation.release()
      @release()

    action = cc.sequence(
      new cc.Animate @_animation
      cc.CallFunc.create cb, this
    )
    @runAction action

module.exports = GreatEffect
