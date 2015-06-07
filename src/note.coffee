FallObj = require './fallObj'

Note = FallObj.extend

  ctor : (texture, @_timer, @_removeTime)->
    @_super texture, @_timer

  update : ->
    @_super()
    time =  @_timer.get()
    @y = @dstY[@index] if @y <= @dstY[@index]

    if @clear and not @hasJudged
      @hasJudged = true
      return

    if time > @timing +  @_removeTime
      @removeFromParent on
      @release()
      return

module.exports = Note
