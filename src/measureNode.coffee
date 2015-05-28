FallObj = require './fallObj'

MeasureNode = FallObj.extend

  ctor : (texture, @_timer)->
    @_super texture, @_timer

  update : ->
    @_super()
    if @y < @dstY[@index] then @removeFromParent on

module.exports = MeasureNode
