Node = cc.Sprite.extend

  ctor : (texture @_timer)->
    @_super texture
    @_index    = 0
    @_nodes    = []
    @_genTime  = []

  #
  # start node update
  #
  start : -> @scheduleUpdate()

  update : ->
    time = @_timer.get()
    while time > node.bpm.timing[node.index]
      if node.index < node.bpm.timing.length - 1 then node.index++
      else break
    diffTime = node.bpm.timing[node.index] - time
    diffDist = diffTime * node.speed[node.index]
    node.y = node.dstY[node.index] - diffDist

    if node.y > node.dstY[node.index]
      @_sys.removeChild @_sys.getCurrentScene(), node
      @_notifier.trigger 'remove', time

module.exports = MeasureNodes
