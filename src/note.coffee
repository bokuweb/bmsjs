FallObj = require './fallObj'

Note = FallObj.extend

  ctor : (texture, @_timer, @_removeTime)->
    @_super texture, @_timer

  update : ->
    @_super()
    time =  @_timer.get()

    if @clear and not @hasJudged
      @hasJudged = true
      return

    if time > @timing +  @_removeTime
      @removeFromParent on
      return

module.exports = Note
