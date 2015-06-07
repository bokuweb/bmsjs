NumeralLayer = cc.Layer.extend
  ctor: (@_skin) ->
    @_super()
    @_sprites = []

  init : (@_digits, num) ->
    scaledWidth = @_skin.width * @_skin.scale
    for i in [0...@_digits]
      @_sprites[i] = new cc.Sprite @_skin.src, cc.rect 0, 0, @_skin.width, @_skin.height
      @_sprites[i].x = i * (-scaledWidth - @_skin.margin) + (scaledWidth * @_digits / 2)
      @_sprites[i].scale = @_skin.scale
      @addChild @_sprites[i]
      num ?= 0
    @reflect num

  reflect : (num) ->
    for i in [0...@_digits]
      @_sprites[i].setTextureRect cc.rect ~~(num % 10) * @_skin.width, 0, @_skin.width, @_skin.height
      num /= 10

module.exports = NumeralLayer
