FallObjsLayer = cc.Layer.extend

  ctor : -> @_super()

  # return object speed [px/msec]
  _calcSpeed : (bpm, fallDist) ->
    measureTime = 240000 / bpm
    fallDist / measureTime

  #
  # append BPM, speed, destination y coordinate list to falling object
  #
  _appendFallParams : (obj, bpms, time, fallDist)->
    size = cc.director.getWinSize()
    previousBpm = 0
    obj.dstY = []
    obj.index = 0
    obj.speed = []
    obj.bpm =
      timing : []
      val : []

    for v, i in bpms when time < v.timing < obj.timing
      obj.bpm.timing.push v.timing
      obj.bpm.val.push v.val

    # calculate bpm before object will be created
    if bpms[0].timing > time then previousBpm = bpms[0].val
    else previousBpm = v.val for v in bpms when v.timing <= time

    obj.dstY[obj.bpm.timing.length] = size.height - fallDist
    obj.bpm.timing.push obj.timing

    # calculate destination of Y coordinate
    for v, i in obj.bpm.timing by -1 when i < obj.bpm.timing.length - 1
      diffDist = (obj.bpm.timing[i+1] - v) * @_calcSpeed(obj.bpm.val[i], fallDist)
      obj.dstY[i] = obj.dstY[i+1] + diffDist
    obj.bpm.val.splice 0, 0, previousBpm

    obj.speed.push @_calcSpeed v, fallDist for v in obj.bpm.val
    return

module.exports = FallObjsLayer
