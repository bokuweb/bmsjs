NumeralLayer = require './numeralLayer'

PlaytimeLayer = cc.Layer.extend
  ctor: (@_skin, @_timer) ->
    @_super()
    @_oldtime = 0
    @_minuite = new NumeralLayer @_skin
    @_second  = new NumeralLayer @_skin

  init :  ->
    @_minuite.init 2, 0
    @_minuite.x = cc.screenSize.width / 2 + @_skin.minuite.x
    @_minuite.y = cc.screenSize.height - @_skin.minuite.y
    @addChild @_minuite

    @_second.init 2, 0
    @_second.x = cc.screenSize.width / 2 + @_skin.second.x
    @_second.y = cc.screenSize.height - @_skin.second.y
    @addChild @_second

  start : -> @scheduleUpdate()

  update : ->
    now = ~~(@_timer.get() / 1000)
    if now isnt @_oldtime
      @_minuite.reflect now / 60
      @_second.reflect now % 60
      @_oldtime = now

module.exports = PlaytimeLayer
