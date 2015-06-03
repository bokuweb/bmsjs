skin =
  z : 10
  judge :
    src    : '../res/judge-image.png'
    width  : 51
    height : 15
    x : 216
    y : 340
  score :
    src    : '../res/numeral-font.png'
    width  : 25
    height : 37.1
    scale  : 0.35
    margin : 3
    x : 202
    y : 175
  pgreatNum :
    src    : '../res/numeral-font.png'
    width  : 25
    height : 37.1
    scale  : 0.3
    margin : 2
    x : 296
    y : 174
  greatNum :
    src    : '../res/numeral-font.png'
    width  : 25
    height : 37.1
    scale  : 0.3
    margin : 2
    x : 296
    y : 165
  goodNum :
    src    : '../res/numeral-font.png'
    width  : 25
    height : 37.1
    scale  : 0.35
    margin : 3
    x : 296
    y : 156
  badNum :
    src    : '../res/numeral-font.png'
    width  : 25
    height : 37.1
    scale  : 0.35
    margin : 3
    x : 297
    y : 147
  poorNum :
    src    : '../res/numeral-font.png'
    width  : 25
    height : 37.1
    scale  : 0.35
    margin : 3
    x : 297
    y : 138
  comboNum :
    src    : '../res/numeral-font.png'
    width  : 25
    height : 37.1
    scale  : 0.35
    margin : 3
    x : 211
    y : 156


StatsLayerTest = cc.Class.extend
  start : ->
    describe 'stats layer class test', ->
      MAX_SCORE = 200000
      TEST_NOTE_NUM = 30
      @timeout 10000
      StatsLayer = require '../../src/statsLayer'
      capture = require './test-utils'
        .capture
      expect  = chai.expect
      capNum = 0

      it 'initialize stats and capture stats', (done)->
        TestScene = cc.Scene.extend
          onEnter : ->
            @_super()
            size = cc.director.getWinSize()
            stats = new StatsLayer skin
            stats.init TEST_NOTE_NUM, MAX_SCORE
            @addChild stats
            expect(stats.get().score).to.be.equal 0
            expect(stats.get().combo).to.be.equal 0
            expect(stats.get().pgreat).to.be.equal 0
            expect(stats.get().great).to.be.equal 0
            expect(stats.get().good).to.be.equal 0
            expect(stats.get().bad).to.be.equal 0
            expect(stats.get().poor).to.be.equal 0
            setTimeout =>
              capture "test/capture/StatsLayer/stats" + capNum++
              done()
            , 1000
        cc.director.runScene new TestScene()

      it 'score is MAX_SCORE when all pgreat', (done)->
        TestScene = cc.Scene.extend
          onEnter : ->
            @_super()
            size = cc.director.getWinSize()
            stats = new StatsLayer skin
            stats.init TEST_NOTE_NUM, MAX_SCORE
            @addChild stats
            stats.reflect 'pgreat' for i in [0...TEST_NOTE_NUM]
            expect(stats.get().score).to.be.equal MAX_SCORE
            expect(stats.get().combo).to.be.equal TEST_NOTE_NUM
            expect(stats.get().pgreat).to.be.equal TEST_NOTE_NUM
            expect(stats.get().great).to.be.equal 0
            expect(stats.get().good).to.be.equal 0
            expect(stats.get().bad).to.be.equal 0
            expect(stats.get().poor).to.be.equal 0
            setTimeout =>
              capture "test/capture/StatsLayer/stats" + capNum++
              done()
            , 1000
        cc.director.runScene new TestScene()

      it 'score is MAX_SCORE * 0.7 when all great', (done)->
        TestScene = cc.Scene.extend
          onEnter : ->
            @_super()
            size = cc.director.getWinSize()
            stats = new StatsLayer skin
            stats.init TEST_NOTE_NUM, MAX_SCORE
            @addChild stats
            stats.reflect 'great' for i in [0...TEST_NOTE_NUM]
            expect(stats.get().score).to.be.equal MAX_SCORE * 0.7
            expect(stats.get().combo).to.be.equal TEST_NOTE_NUM
            expect(stats.get().pgreat).to.be.equal 0
            expect(stats.get().great).to.be.equal TEST_NOTE_NUM
            expect(stats.get().good).to.be.equal 0
            expect(stats.get().bad).to.be.equal 0
            expect(stats.get().poor).to.be.equal 0
            setTimeout =>
              capture "test/capture/StatsLayer/stats" + capNum++
              done()
            , 1000
        cc.director.runScene new TestScene()

      it 'score is MAX_SCORE * 0.5 when all good', (done)->
        TestScene = cc.Scene.extend
          onEnter : ->
            @_super()
            size = cc.director.getWinSize()
            stats = new StatsLayer skin
            stats.init TEST_NOTE_NUM, MAX_SCORE
            @addChild stats
            stats.reflect 'good' for i in [0...TEST_NOTE_NUM]
            expect(stats.get().score).to.be.equal MAX_SCORE * 0.5
            expect(stats.get().combo).to.be.equal TEST_NOTE_NUM
            expect(stats.get().pgreat).to.be.equal 0
            expect(stats.get().great).to.be.equal 0
            expect(stats.get().good).to.be.equal TEST_NOTE_NUM
            expect(stats.get().bad).to.be.equal 0
            expect(stats.get().poor).to.be.equal 0
            setTimeout =>
              capture "test/capture/StatsLayer/stats" + capNum++
              done()
            , 1000
        cc.director.runScene new TestScene()

      it 'score is 0 when all bad', (done)->
        TestScene = cc.Scene.extend
          onEnter : ->
            @_super()
            size = cc.director.getWinSize()
            stats = new StatsLayer skin
            stats.init TEST_NOTE_NUM, MAX_SCORE
            @addChild stats
            stats.reflect 'bad' for i in [0...TEST_NOTE_NUM]
            expect(stats.get().score).to.be.equal 0
            expect(stats.get().combo).to.be.equal 0
            expect(stats.get().pgreat).to.be.equal 0
            expect(stats.get().great).to.be.equal 0
            expect(stats.get().good).to.be.equal 0
            expect(stats.get().bad).to.be.equal TEST_NOTE_NUM
            expect(stats.get().poor).to.be.equal 0
            setTimeout =>
              capture "test/capture/StatsLayer/stats" + capNum++
              done()
            , 1000
        cc.director.runScene new TestScene()

      it 'score is 0 when all poor', (done)->
        TestScene = cc.Scene.extend
          onEnter : ->
            @_super()
            size = cc.director.getWinSize()
            stats = new StatsLayer skin
            stats.init TEST_NOTE_NUM, MAX_SCORE
            @addChild stats
            stats.reflect 'poor' for i in [0...TEST_NOTE_NUM]
            expect(stats.get().score).to.be.equal 0
            expect(stats.get().combo).to.be.equal 0
            expect(stats.get().pgreat).to.be.equal 0
            expect(stats.get().great).to.be.equal 0
            expect(stats.get().good).to.be.equal 0
            expect(stats.get().bad).to.be.equal 0
            expect(stats.get().poor).to.be.equal TEST_NOTE_NUM
            setTimeout =>
              capture "test/capture/StatsLayer/stats" + capNum++
              done()
            , 1000
        cc.director.runScene new TestScene()

      it 'all judge num is 6', (done)->
        TestScene = cc.Scene.extend
          onEnter : ->
            @_super()
            size = cc.director.getWinSize()
            stats = new StatsLayer skin
            stats.init TEST_NOTE_NUM, MAX_SCORE
            @addChild stats
            for i in [0...TEST_NOTE_NUM / 5]
              stats.reflect 'pgreat'
              stats.reflect 'great'
              stats.reflect 'good'
              stats.reflect 'bad'
              stats.reflect 'poor'
            expect(stats.get().score).to.be.equal ~~((MAX_SCORE / TEST_NOTE_NUM * 13.2).toFixed())
            expect(stats.get().combo).to.be.equal 3
            expect(stats.get().pgreat).to.be.equal 6
            expect(stats.get().great).to.be.equal 6
            expect(stats.get().good).to.be.equal 6
            expect(stats.get().bad).to.be.equal 6
            expect(stats.get().poor).to.be.equal 6
            setTimeout =>
              capture "test/capture/StatsLayer/stats" + capNum++
              done()
            , 1000
        cc.director.runScene new TestScene()

module.exports = StatsLayerTest


