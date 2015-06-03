POOR_INDICATOR_TIME_MSEC = 200

BpmLayer = cc.Layer.extend
  ctor: (@_skin, @_timer) ->
    @_super()

  init : (@_srcs, @_bmps) ->
    @_index = 0
    @_isPoor = false
    @_bmp = new cc.Sprite()
    @_bmp.x = @_skin.x
    @_bmp.y = @_skin.y
    @_bmp.width = @_skin.width
    @_bmp.height = @_skin.height
    @_bmp.scale = 2
    @addChild @_bmp

  start : -> @scheduleUpdate()

  onPoor : ->
    @_isPoor = true
    @_bmp.initWithSpriteFrameName @_srcs[0]
    @schedule @_disablePoor, POOR_INDICATOR_TIME_MSEC / 1000

  update : ->
    time = @_timer.get()
    if @_bmps[@_index]?
      if time > @_bmps[@_index].timing
        @_bmp.initWithSpriteFrameName @_srcs[@_bmps[0].id] unless @_isPoor
        @_index++

  _disablePoor : -> @_isPoor = false

module.exports = BpmLayer
