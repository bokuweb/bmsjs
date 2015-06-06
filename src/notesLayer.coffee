EventObserver     = require './eventObserver'
Judge             = require './judge'
Note              = require './note'
GreatEffectsLayer = require './greatEffectsLayer'
KeyEffectsLayer   = require './keyEffectsLayer'
MeasureNode       = require './measureNode'

NotesLayer = cc.Layer.extend
  ctor : (@_skin, @_timer, @_config)->
    @_super()
    @_notifier = new EventObserver()
    @_judge = new Judge()
    @_greatEffectsLayer = new GreatEffectsLayer @_skin.greatEffect
    @_keyEffectsLayer = new KeyEffectsLayer @_skin.keyEffect
    @_notes = []
    @_nodes    = []
    @_genTime = []

  #
  # create notes
  #
  init : (bms)->
    time = 0
    @_index = 0
    @_notes.length = 0
    @_nodes.length = 0
    @_genTime.length = 0

    for v, i in bms.data
      node = new MeasureNode @_skin.nodeImage.src, @_timer
      node.x = @_skin.nodeImage.x
      node.timing = v.timing
      node.appendFallParams bms.bpms, time, @_skin.fallDist
      @_genTime.push time
      time = @_getGenTime node, @_skin.fallDist
      @_nodes.push node
      node.retain()
      
    @_genTime.sort (a, b) -> a - b

    bg = new cc.Sprite @_skin.bgImage.src
    bg.setAnchorPoint cc.p(0.5, 0)
    bg.x = @_skin.bgImage.x
    bg.y = @_skin.bgImage.y
    bg.setOpacity 180
    @addChild bg, 0
    @_greatEffectsLayer.init bms.totalNote
    @addChild @_greatEffectsLayer, 10

    @_generate bms, measure, time for time, measure in @_genTime
    xList = for i in [0...@_skin.keyNum] then @_calcNoteXCoordinate i
    @_keyEffectsLayer.init xList
    @addChild @_keyEffectsLayer, 0

  addListener: (name, listner)->
    @_notifier.on name, listner

  #
  # generate and pool note
  #
  _generate : (bms, measure, time)->
    turntable = @_skin.noteTurntableImage
    white = @_skin.noteWhiteImage
    black = @_skin.noteBlackImage
    fallDist = @_skin.fallDist
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
        note.retain()
        @_notes[measure].push note
    return

  #
  # calculate
  #
  _calcNoteXCoordinate : (id)->
    turntable = @_skin.noteTurntableImage
    white = @_skin.noteWhiteImage
    black = @_skin.noteBlackImage
    offset = @_skin.offsetX
    margin = (id + 1) * @_skin.marginX
    switch id
      when 0, 2, 4, 6
        ~~(id / 2) * (black.width + white.width) + (turntable.width + white.width) / 2 + offset + margin
      when 1, 3, 5
        ~~(id / 2) * (black.width + white.width) + (turntable.width + black.width) / 2 + offset + margin + white.width
      when 7
        offset
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
    return if @_isAuto
    @_keyEffectsLayer.show key, 0.5
    for note in @children when note.key is key
      diffTime = note.timing - time
      unless note.clear
        if -@_config.reactionTime < diffTime < @_config.reactionTime
          note.clear = true
          @_notifier.trigger 'hit', note.wav
          judgement = @_judge.exec diffTime
          @_notifier.trigger 'judge', judgement
          if judgement is 'pgreat' or 'great'
            size = cc.director.getWinSize()
            y = size.height - @_skin.fallDist
            @_greatEffectsLayer.run note.x, y
          return
        else
          @_notifier.trigger 'judge', 'epoor'
          return
    return

  #
  # add note to game scene
  # @attention - _add called by window
  #
  update : ->
    if @_isAuto
      for child in @children when child.clear is false
        if @_timer.get() >= child.timing
          @_keyEffectsLayer.show child.key, 0.5
          child.clear = true
          y = cc.director.getWinSize().height - @_skin.fallDist
          @_greatEffectsLayer.run child.x, y
          @_notifier.trigger 'judge', 'pgreat'
          @_notifier.trigger 'hit', child.wav

    return unless @_genTime[@_index]?
    return unless @_genTime[@_index] <= @_timer.get()

    # FIXME : ここでエラー
    #         配列にプールしているのがまずい？
    #         cc.poolを使わなくては？
    #         propのみ配列に保持。spriteはcc.pool
    @addChild @_nodes[@_index]
    @_nodes[@_index].start()
    for note in @_notes[@_index]
      @addChild note, 5
      note.start()
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
    
module.exports = NotesLayer
