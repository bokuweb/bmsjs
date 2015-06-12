NumeralLayer = cc.Layer.extend
  ctor: (@_skin) ->
    @_super()
    @_sprites = []

  init : (@_digits, num = 0) ->
    scaledWidth = @_skin.width * @_skin.scale
    @_batchNode = new cc.SpriteBatchNode @_skin.src
    @addChild @_batchNode
    @_frames = for i in [0...10]
      new cc.SpriteFrame @_batchNode.texture, cc.rect @_skin.width * i, 0, @_skin.width, @_skin.height

    for i in [0...@_digits]
      @_sprites[i] = new cc.Sprite()
      @_sprites[i].setSpriteFrame @_frames[0]
      @_sprites[i].x = i * (-scaledWidth - @_skin.margin) + (scaledWidth * @_digits / 2)
      @_sprites[i].scale = @_skin.scale
      @_batchNode.addChild @_sprites[i]
    @reflect num

  reflect : (num) ->
    for i in [0...@_digits]
      @_sprites[i].setSpriteFrame @_frames[~~(num % 10)]
      num /= 10

module.exports = NumeralLayer
