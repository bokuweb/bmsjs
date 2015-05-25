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
      #judgement = @_judge.exec note.diffTime
      #@_notifier.trigger judgement
      return

    if time > @timing +  @_removeTime
      @removeFromParent on
      #@_notifier.trigger 'poor' unless note.clear
      return
    # Auto Play
    ### 
    if @_isAuto
      if time >= note.timing and not note.clear
        @_keyDownEffect.show note.key
        note.clear = true
        note.hasJudged = true
        @_notifier.trigger 'pgreat'
        @_notifier.trigger 'hit', note.wav
    ###
module.exports = Note
