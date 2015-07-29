POOR_INDICATOR_TIME_MSEC = 200

AnimationLayer = cc.Layer.extend
  ctor: (@_skin, @_timer) ->
    @_super()
    @_srcs = []

  init : (srcs, @_bmps, prefix) ->
    @_index = 0
    @_isPoor = false
    @_srcs[k] = prefix + v for k, v of srcs
    @_bmp = new cc.Sprite @_srcs[0]
    @_bmp.x = cc.screenSize.width / 2 + @_skin.x
    @_bmp.y = cc.screenSize.height - @_skin.y
    #@_bmp.width = @_skin.width
    #@_bmp.height = @_skin.height
    @_bmp.scale = 2
    @addChild @_bmp

  start : -> @scheduleUpdate()

  onPoor : ->
    @_isPoor = true
    @_bmp.setTexture @_srcs[0]
    @scheduleOnce @_disablePoor, POOR_INDICATOR_TIME_MSEC / 1000

  update : ->
    time = @_timer.get()
    if time > @_bmps[@_index]?.timing
      @_bmp.setTexture @_srcs[@_bmps[@_index].id] unless @_isPoor
      @_index++

  _disablePoor : -> @_isPoor = false

module.exports = AnimationLayer
