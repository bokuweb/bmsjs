FallObjsLayer = require './fallObjsLayer'
Node          = require './measureNode'

MeasureNodesLayer = FallObjsLayer.extend

  ctor : (@_timer)->
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
  init : (skin, bms)->
    time = 0
    @_nodes.length = 0
    @_genTime.length = 0

    for v, i in bms.data
      node = new Node skin.nodeImage.src, @_timer
      node.x = skin.offset
      node.timing = v.timing
      @_appendFallParams node, bms.bpms, time, skin.fallDist
      @_genTime.push time
      time = @_getGenTime node, skin.fallDist
      @_nodes.push node
    @_genTime

  #
  # start node update
  #
  start : -> @scheduleUpdate()

  #
  # add note to game scene
  #
  update : ->
    return unless @_genTime[@_index]?
    return unless @_genTime[@_index] <= @_timer.get()
    @addChild @_nodes[@_index]
    @_nodes[@_index].start()
    @_index++

  _calcSpeed : (bpm, fallDistance) ->
    @_super bpm, fallDistance

  _appendFallParams : (obj, bpms, time, fallDistance)->
    @_super obj, bpms, time, fallDistance
  #
  # get time when node y coordinate will be 0px
  # to generate next node
  #
  _getGenTime : (obj, fallDist)->
    size = cc.director.getWinSize()
    for v, i in obj.dstY when v < size.height
      return ~~(obj.bpm.timing[i] - (v / @_calcSpeed(obj.bpm.val[i], fallDist)))
    return 0

module.exports = MeasureNodesLayer
