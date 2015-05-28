EventObserver = require './eventObserver'
Note          = require './note'

NotesLayer = cc.Layer.extend

  ctor : (@_skin, @_timer, @_config)->
    @_super()
    @_notifier = new EventObserver()
    @_notes = []
    @_genTime = []

  #
  # create notes
  #
  init : (bms, @_genTime)->
    @_index = 0
    @_notes.length = 0
    @_generate bms, measure, time for time, measure in @_genTime
    xArr = for i in [0...@_skin.fallObj.keyNum] then @_calcNoteXCoordinate i

  addListener: (name, listner)->
    @_notifier.on name, listner

  #
  # generate and pool note
  #
  _generate : (bms, measure, time)->
    turntable = @_skin.fallObj.noteTurntableImage
    white = @_skin.fallObj.noteWhiteImage
    black = @_skin.fallObj.noteBlackImage
    fallDist = @_skin.fallObj.fallDist
    bpms = bms.bpms
    @_notes[measure] ?= []

    return unless bms.data[measure]?
    for key, i in bms.data[measure].note.key
      for timing, j in key.timing
        switch i
          when 0, 2, 4, 6
            note = new Note white.src, @_timer, @_config.removeTime
          when 1, 3, 5
            note = new Note black.src, @_timer, @_config.removeTime
          when 7
            note = new Note turntable.src, @_timer, @_config.removeTime
          else throw new Error "error unlnown note"

        note.x = @_calcNoteXCoordinate i
        note.y = -note.height
        note.setAnchorPoint cc.p(0.5,0)
        note.timing = timing
        note.wav = key.id[j]
        note.key = i
        note.clear = false
        note.appendFallParams bpms, time, fallDist
        @_notes[measure].push note
    return

  #
  # calculate
  #
  _calcNoteXCoordinate : (id)->
    turntable = @_skin.fallObj.noteTurntableImage
    white = @_skin.fallObj.noteWhiteImage
    black = @_skin.fallObj.noteBlackImage
    offset = @_skin.fallObj.offset
    margin = (id + 1) * @_skin.fallObj.margin
    switch id
      when 0, 2, 4, 6
        return ~~(id / 2) * (black.width + white.width) + turntable.width + offset + margin
      when 1, 3, 5
        return ~~(id / 2) * (black.width + white.width) + turntable.width + offset + margin + white.width
      when 7
        return offset
      else throw new Error "error unlnown note"

  #
  # start note update
  #
  # @param  isAuto - 
  #
  start : (autoplay = false)->
    @scheduleUpdate()
    @_isAuto = autoplay

  onTouch : (key, time)->
    for note in @children when note.key is key
      diffTime = note.timing - time
      unless note.clear
        if -@_config.reactionTime < diffTime < @_config.reactionTime
          note.clear = true
          note.diffTime = diffTime
          @_notifier.trigger 'hit', note.wav
          return
        else
          #@_notifier.trigger 'judge', 'epoor'
          return
    return
  #
  # add note to game scene
  # @attention - _add called by window
  #
  update : ->
    if @_isAuto
      for note in @children
        if @_timer.get() >= note.timing and not note.clear
          #@_keyDownEffect.show note.key
          note.clear = true
          #note.hasJudged = true
          @_notifier.trigger 'judge', 'pgreat'
          @_notifier.trigger 'hit', note.wav

    return unless @_genTime[@_index]?
    return unless @_genTime[@_index] <= @_timer.get()
    for note in @_notes[@_index]
      @addChild note
      note.start()
    @_index++



module.exports = NotesLayer
