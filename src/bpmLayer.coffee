NumeralLayer = require './numeralLayer'

BpmLayer = cc.Layer.extend
  ctor: (@_skin, @_timer, @_bpms) ->
    @_super()
    @_bpm = new NumeralLayer @_skin

  init : ->
    @_index = 0
    @_bpm.init 3, @_bpms[0].val
    @_bpm.x = cc.screenSize.width / 2 + @_skin.x
    @_bpm.y = cc.screenSize.height - @_skin.y
    @addChild @_bpm

  start : -> @scheduleUpdate()

  get : ->
    i = if @_index >= 1 then @_index - 1 else 0
    @_bpms[i].val

  update : ->
    time = @_timer.get()
    if @_bpms[@_index]?
      if time > @_bpms[@_index].timing
        @_bpm.reflect @_bpms[@_index].val
        @_index++

module.exports = BpmLayer

