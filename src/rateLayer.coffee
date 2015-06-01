NumeralLayer = require './numeralLayer'

RateLayer = cc.Layer.extend
  ctor : (@_skin)->
    @_super()
    @_label = new NumeralLayer @_skin.label
    @_sprites = []

  init : (@_config)->
    for i in [0...@_config.num]
      @_sprites[i] = new cc.Sprite @_skin.meter.src, cc.rect 0, 0, @_skin.meter.width, @_skin.meter.height
      @_sprites[i].x = @_skin.meter.x + i * @_skin.meter.width
      @_sprites[i].y = @_skin.meter.y
      @addChild @_sprites[i]
    @_rate = @_config.initRate

    @_label.init 3, 0
    @_label.x = @_skin.label.x
    @_label.y = @_skin.label.y
    @addChild @_label

  get : -> ~~(@_rate.toFixed())

  start : -> @scheduleUpdate()

  update : ->
    w = @_skin.meter.width
    h = @_skin.meter.height
    for i in [0...@_config.num]
      if i > @_config.clearVal
        if @_rate - 6 <= i * 2 < @_rate - 2
          @_sprites[i].setTextureRect cc.rect  ~~(Math.random() * 2) * 2 * w, 0, w, h
        else if @_rate - 2 >= i * 2 then @_sprites[i].setTextureRect cc.rect  0, 0, w, h
        else @_sprites[i].setTextureRect cc.rect  w * 2, 0, w, h
      else
        if @_rate - 6 <= i * 2 < @_rate - 2 then @_sprites[i].setTextureRect cc.rect  (~~(Math.random() * 2) * 2 + 1) * w, 0, w, h
        else if @_rate - 2 >= i * 2 then @_sprites[i].setTextureRect cc.rect  w, 0, w, h
        else @_sprites[i].setTextureRect cc.rect  w * 3, 0, w, h
    return

  reflect : (judge) ->
    switch judge
      when "pgreat", "great"
        @_rate = if @_rate + @_config.greatIncVal > 100 then 100 else @_rate + @_config.greatIncVal
      when "good"
        @_rate = if @_rate + @_config.goodIncVal > 100 then 100 else @_rate + @_config.goodIncVal
      when "bad"
        @_rate = if @_rate - @_config.badDecVal < 2 then 2 else @_rate - @_config.badDecVal
      when "poor"
        @_rate = if @_rate - @_config.poorDecVal < 2 then 2 else @_rate - @_config.poorDecVal
      else
        @_rate = if @_rate - @_config.poorDecVal < 2 then 2 else @_rate - @_config.poorDecVal

    @_label.reflect ~~(@_rate.toFixed())

module.exports = RateLayer
