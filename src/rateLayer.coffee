NumeralLayer = require './numeralLayer'

RateLayer = cc.Layer.extend
  ctor : (@_skin) ->
    @_super()
    @_label = new NumeralLayer @_skin.label
    @_sprites = []
    @_count = 0

  init : (@_config) ->
    @_batchNode = new cc.SpriteBatchNode @_skin.meter.src
    @addChild @_batchNode
    @_frames = for i in [0...4]
      new cc.SpriteFrame @_batchNode.texture, cc.rect @_skin.meter.width * i, 0, @_skin.meter.width, @_skin.meter.height

    for i in [0...@_config.num]
      @_sprites[i] = new cc.Sprite()
      @_sprites[i].setSpriteFrame @_frames[0]
      @_sprites[i].x = cc.screenSize.width / 2 + @_skin.meter.x + i * @_skin.meter.width
      @_sprites[i].y = cc.screenSize.height - @_skin.meter.y
      @_batchNode.addChild @_sprites[i]
    @_rate = @_config.initRate

    @_label.init 3, 0
    @_label.x = cc.screenSize.width / 2 + @_skin.label.x
    @_label.y = cc.screenSize.height - @_skin.label.y
    @addChild @_label
    @_label.reflect ~~(@_rate.toFixed())

    console.log @_config.great
    

  get : -> ~~(@_rate.toFixed())

  start : -> @scheduleUpdate()

  update : ->
    @_count += 1
    return unless @_count % 4 is 0
    w = @_skin.meter.width
    h = @_skin.meter.height
    base = if @_rate - 6 then 0 else @_rate
    for i in [base...@_config.num]
      if i > @_config.clearVal
        if @_rate - 6 <= i * 2 < @_rate - 2
          @_sprites[i].setSpriteFrame @_frames[~~(Math.random() * 2) * 2]
        else if @_rate - 2 >= i * 2 then @_sprites[i].setSpriteFrame @_frames[0]
        else @_sprites[i].setSpriteFrame @_frames[2]
      else
        if @_rate - 6 <= i * 2 < @_rate - 2 then @_sprites[i].setSpriteFrame @_frames[~~(Math.random() * 2) * 2 + 1]
        else if @_rate - 2 >= i * 2 then @_sprites[i].setSpriteFrame @_frames[1]
        else @_sprites[i].setSpriteFrame @_frames[3]
    return


  reflect : (judge) ->
    switch judge
      when "pgreat", "great"
        if @_rate + @_config.great >= 100 then @_rate = 100 else @_rate += @_config.great
      when "good"
        if @_rate + @_config.good >= 100 then @_rate = 100 else @_rate += @_config.good
      when "bad"
        if @_rate + @_config.bad < 2 then @_rate = 2 else @_rate += @_config.bad
      when "poor"
        if @_rate + @_config.poor < 2 then @_rate = 2 else @_rate += @_config.poor
      when "epoor"
        @_rate = if @_rate + @_config.epoor < 2 then @_rate = 2 else @_rate += @_config.epoor
      else

    @_label.reflect ~~(@_rate.toFixed())

module.exports = RateLayer
