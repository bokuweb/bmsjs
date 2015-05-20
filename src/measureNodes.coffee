FallObjs = require './fallObjs'

# TODO : fix Layer
MeasureNodes = cc.Sprite.extend extends FallObjs

  ctor : (@_sys, @_timer)->
    @_super()
    @_index    = 0
    @_nodes    = []
    @_genTime  = []

  #
  # create and pool nodes
  #
  # @param  res   - resouce data
  # @param  bpms  - BPM change list
  # @param  nodes - node parameter
  # @return node generation time Array
  #
  init : (res, bpms, nodes)->
    time = 0
    @_nodes.length = 0
    @_genTime.length = 0

    for v, i in nodes
      node = new cc.Sprite res.nodeImage.src
      node.timing = v.timing
      #node.x = res.nodeImage.x
      #node.y = res.nodeImage.y

      @_appendFallParams node, bpms, time, res.fallDist
      @_genTime.push time
      time = @_getGenTime node, res.fallDist
      @_nodes.push node
    @_genTime

  #
  # start node update
  #
  start : -> @_scheduleId = @_sys.setScheduler @_add

  #
  # stop node update
  #
  stop : -> @_sys.clearScheduler @_scheduleId

  _calcSpeed : (bpm, fallDistance) ->
    @_super bpms, fallDistance

  _appendFallParams : (obj, bpms, time, fallDistance)->
    @_super obj, bpms, time, fallDistance
  #
  # get time when node y coordinate will be 0px
  # to generate next node
  #
  _getGenTime : (obj, fallDist)->
    for v, i in obj.dstY when v > 0
      return ~~(obj.bpm.timing[i] - (v / @_calcSpeed(obj.bpm.val[i], fallDist)))
    return 0

  #
  # add note to game scene
  #
  _add : =>
    return unless @_genTime[@_index]?
    return unless @_genTime[@_index] <= @_timer.get()
    @_sys.addChild @_sys.getCurrentScene(), @_nodes[@_index]
    @_sys.setScheduler @_update.bind(@, @_nodes[@_index]), @_nodes[@_index]
    @_index++

  #
  # update node by FPS
  #
  _update : (node)->
    time = @_timer.get()
    while time > node.bpm.timing[node.index]
      if node.index < node.bpm.timing.length - 1 then node.index++
      else break
    diffTime = node.bpm.timing[node.index] - time
    diffDist = diffTime * node.speed[node.index]
    node.y = node.dstY[node.index] - diffDist

    if node.y > node.dstY[node.index]
      @_sys.removeChild @_sys.getCurrentScene(), node

module.exports = MeasureNodes
