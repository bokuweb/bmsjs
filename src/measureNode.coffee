MeasureNode = cc.Sprite.extend

  ctor : (texture, @_timer)->
    @_super texture

  start : -> @scheduleUpdate()

  update : ->
    time = @_timer.get()
    while time > @bpm.timing[@index]
      if @index < @bpm.timing.length - 1 then @index++
      else break
    diffTime = @bpm.timing[@index] - time
    diffDist = diffTime * @speed[@index]
    @y = @dstY[@index] + diffDist
    if @y < @dstY[@index] then @removeFromParent on

module.exports = MeasureNode
