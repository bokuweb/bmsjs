RateLayer = cc.Layer.extend
  ctor : (@_res)->
    @_super()
    @_sprites = []

  init : (@_config)->
    for i in [0...@_config.num]
      @_sprites[i] = new cc.Sprite @_res.gauge.src, cc.rect 0, 0, @_res.gauge.width, @_res.gauge.height
      @_sprites[i].x = @_res.gauge.x + i * @_res.gauge.width
      @_sprites[i].y = @_res.gauge.y
      @addChild @_sprites[i]
    @_rate = @_config.initRate
    ###
    @_rateLabel = @_sys.createLabel res.rateLabel.font, res.rateLabel.color, res.rateLabel.align
    @_rateLabel.x = res.rateLabel.x
    @_rateLabel.y = res.rateLabel.y
    @_sys.setText @_rateLabel, ~~@_rate + "%"
    @_sys.addChild @_sys.getCurrentScene(), @_rateLabel, res.rateLabel.z
    ###

  get : -> ~~(@_rate.toFixed())

  start : -> @scheduleUpdate()

  update : ->
    w = @_res.gauge.width
    h = @_res.gauge.height
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

    #@_sys.setText @_rateLabel, ~~(@_rate.toFixed()) + "%"

module.exports = RateLayer
