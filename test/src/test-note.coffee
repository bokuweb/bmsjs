NoteTest = cc.Class.extend

  start : ->
    describe 'note class test', ->
      @timeout 10000
      Note    = require '../../src/note'
      Timer   = require '../../src/timer'
      capture = require './test-utils'
        .capture
      expect  = chai.expect
      capNum = 0

      it 'note create and update test', (done)->
        TestScene = cc.Scene.extend
          onEnter : ->
            @_super()
            @_timer = new Timer()
            note = new Note '../res/note-white.png', @_timer, 100
            note.x = 160
            note.y = -note.height
            note.timing = 2000
            note.clear = false
            note.appendFallParams [timing : 0, val : 180], 0, 400
            @addChild note
            note.start()
            @_timer.start()
            expect @children.length
              .to.be.equal 1

            setTimeout =>
              capture "capture/notes/notes" + capNum++
            , 2000

            setTimeout =>
              expect @children.length
                .to.be.equal 0
              done()
            , 2500

        cc.director.runScene new TestScene()

      before ->

      after ->


module.exports = NoteTest


