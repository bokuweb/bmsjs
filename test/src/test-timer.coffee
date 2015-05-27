describe 'timer class test', ->
  Timer  = require '../../src/timer'
  expect = chai.expect
  timer  = null

  it 'should timer.get() return 0 before start', (done)->
    MyScene = cc.Scene.extend
      onEnter : ->
        @_super()
        size = cc.director.getWinSize()
        label = cc.LabelTTF.create("abcd", "Arial", 40)
        label.setPosition(size.width / 2, size.height / 2)
        @addChild label, 1
        @scheduleOnce @test, 1

      test : ->
        console.log "test"
        done()

    cc.director.runScene new MyScene()

  before ->
    timer = new Timer()

  after ->
    MyScene = cc.Scene.extend
      onEnter : ->
        @_super()
        size = cc.director.getWinSize()
        label = cc.LabelTTF.create("abcdef", "Arial", 40)
        label.setPosition(size.width / 2, size.height / 2)
        @addChild label, 1

    cc.director.runScene new MyScene()


