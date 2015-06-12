FallObj       = require './fallObj'
EventObserver = require './eventObserver'

Note = FallObj.extend

  ctor : (texture, @_timer, @_removeTime) ->
    @_super texture, @_timer
    @_notifier = new EventObserver()

  addListener: (name, listner) ->
    @_notifier.on name, listner

  update : ->
    @_super()
    time =  @_timer.get()
    @y = @dstY[@index] if @y <= @dstY[@index]

    if @clear and not @hasJudged
      @hasJudged = true
      return

    if time > @timing +  @_removeTime
      @_notifier.trigger 'remove', this
      @removeFromParent on
      @release()
      return

module.exports = Note
