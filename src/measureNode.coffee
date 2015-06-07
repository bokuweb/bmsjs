FallObj = require './fallObj'

MeasureNode = FallObj.extend

  ctor : (texture, @_timer)->
    @_super texture, @_timer

  start : ->
    @_super()
    
  update : ->
    @_super()
    if @y < @dstY[@index]
      @removeFromParent on
      @release()

module.exports = MeasureNode
