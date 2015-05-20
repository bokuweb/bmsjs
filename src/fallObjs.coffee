FallObj = cc.Class.extend

  ctor : -> @_super()
  
  # return object speed [px/msec]
  _calcSpeed : (bpm, fallDistance) ->
    measureTime = 240000 / bpm
    fallDistance / measureTime

  #
  # append BPM, speed, destination y coordinate list to falling object
  #
  _appendFallParams : (obj, bpms, time, fallDistance)->
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

    obj.dstY[obj.bpm.timing.length] = fallDistance
    obj.bpm.timing.push obj.timing

    # calculate destination of Y coordinate
    for v, i in obj.bpm.timing by -1 when i < obj.bpm.timing.length - 1
      diffDistance = (obj.bpm.timing[i+1] - v) * @_calcSpeed(obj.bpm.val[i], fallDistance)
      obj.dstY[i] = obj.dstY[i+1] - diffDistance
    obj.bpm.val.splice 0, 0, previousBpm

    for v in obj.bpm.val then obj.speed.push @_calcSpeed v, fallDistance
    return

module.exports = FallObj
