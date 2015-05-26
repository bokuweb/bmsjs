describe 'timer class test', ->
  Timer  = require '../../src/timer'
  expect = chai.expect
  timer  = null
  it 'should timer.get() return 0 before start', ->
    time = timer.get()
    expect time
      .to.be.equal 0

  it 'set timer 1000msec, should get() return about 1000msec', (done)->
    timer.start()
    setTimeout ->
      time = timer.get()
      expect time
        .to.be.within 950, 1050
      done()
    , 1000

  before ->
    timer = new Timer()
