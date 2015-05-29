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

    animation = new cc.Animation animationframe, params.delay
    cb = -> @removeFromParent on
    @_action = cc.sequence(
      new cc.animate animation
      cc.CallFunc.create cb, this
    )

  run : -> @runAction @_action

module.exports = GreatEffect
