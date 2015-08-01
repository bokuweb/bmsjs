Timer = cc.Class.extend
  ctor : ->
    @_startTime = 0
    @_pauseTime = 0
    @_isPause   = false

  start : ->
    @_isPause = false
    @_startTime  = new Date()

  set : (time_msec)->
    @_startTime  = new Date()
    @_pauseTime = time_msec

  get : ->
    if @_isPause
      @_pauseTime
    else if @_startTime
      ((new Date() - @_startTime) + @_pauseTime)
    else 0

  pause : ->
    @_isPause = true
    @_pauseTime = ((new Date() - @_startTime) + @_pauseTime)

  stop : ->
    @_startTime = 0
    @_pauseTime = 0

module.exports = Timer
