Note = cc.Sprite.extend

  ctor : (texture, @_timer, @_removeTime)->
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

    if @clear and not @hasJudged
      @hasJudged = true
      return

    if time > @timing +  @_removeTime
      @removeFromParent on
      return
  #
  # append BPM, speed, destination y coordinate list to falling object
  #
  appendFallParams : (bpms, time, fallDist)->
    size = cc.director.getWinSize()
    previousBpm = 0
    @dstY = []
    @index = 0
    @speed = []
    @bpm =
      timing : []
      val : []

    for v, i in bpms when time < v.timing < @timing
      @bpm.timing.push v.timing
      @bpm.val.push v.val

    # calculate bpm before object will be created
    if bpms[0].timing > time then previousBpm = bpms[0].val
    else previousBpm = v.val for v in bpms when v.timing <= time

    @dstY[@bpm.timing.length] = size.height - fallDist
    @bpm.timing.push @timing

    # calculate destination of Y coordinate
    for v, i in @bpm.timing by -1 when i < @bpm.timing.length - 1
      diffDist = (@bpm.timing[i+1] - v) * @_calcSpeed(@bpm.val[i], fallDist)
      @dstY[i] = @dstY[i+1] + diffDist
    @bpm.val.splice 0, 0, previousBpm

    @speed.push @_calcSpeed v, fallDist for v in @bpm.val
    return

  # return object speed [px/msec]
  _calcSpeed : (bpm, fallDist) ->
    measureTime = 240000 / bpm
    fallDist / measureTime


module.exports = Note
