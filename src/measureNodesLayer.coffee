Node = require './measureNode'

MeasureNodesLayer = cc.Layer.extend

  ctor : (@_timer)->
    @_super()
    @_index    = 0
    @_nodes    = []
    @_genTime  = []

  #
  # preallocate nodes
  #
  # @param  skin  - fall object skin data
  # @param  bms   - bms data
  # @return node generation time Array
  #
  init : (skin, bms)->
    time = 0
    @_nodes.length = 0
    @_genTime.length = 0

    for v, i in bms.data
      node = new Node skin.nodeImage.src, @_timer
      node.x = skin.nodeImage.x
      node.timing = v.timing
      node.appendFallParams bms.bpms, time, skin.fallDist
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

  #
  # get time when node y coordinate will be game.height
  # to generate next node
  #
  _getGenTime : (obj, fallDist)->
    size = cc.director.getWinSize()
    for v, i in obj.dstY when v < size.height
      return ~~(obj.bpm.timing[i] - (v / obj.calcSpeed(obj.bpm.val[i], fallDist)))
    return 0

module.exports = MeasureNodesLayer
