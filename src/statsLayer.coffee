NumeralLayer = require './numeralLayer'

StatsLayer = cc.Layer.extend
  ctor: (@_skin) ->
    @_super()
    @_scoreLabel = new NumeralLayer @_skin.score

  init : (noteNum, maxScore) ->
    @_score = 0
    @_dispScore = 0
    @_maxCombo = 0
    @_combo = 0
    @_pgreatNum = 0
    @_greatNum = 0
    @_goodNum = 0
    @_badNum = 0
    @_poorNum = 0
    @_pgreatIncVal = maxScore / noteNum
    @_greatIncVal = maxScore / noteNum * 0.7
    @_goodIncVal = maxScore / noteNum * 0.5
    @_scoreLabel.init @_getDigits(maxScore), 0
    @_scoreLabel.x = @_skin.score.x
    @_scoreLabel.y = @_skin.score.y
    @addChild @_scoreLabel

  get : ->
    score  : @_dispScore
    combo  : @_maxCombo
    pgreat : @_pgreatNum
    great  : @_greatNum
    good   : @_goodNum
    bad    : @_badNum
    poor   : @_poorNum

  reflect : (judge) ->
    switch judge
      when "pgreat"
        @_score += @_pgreatIncVal
        @_combo++
        @_pgreatNum++
        if @_combo > @_maxCombo then @_maxCombo = @_combo
      when "great"
        @_score += @_greatIncVal
        @_combo++
        @_greatNum++
        if @_combo > @_maxCombo then @_maxCombo = @_combo
      when "good"
        @_score += @_goodIncVal
        @_combo++
        @_goodNum++
        if @_combo > @_maxCombo then @_maxCombo = @_combo
      when "bad"
        @_combo = 0
        @_badNum++
      else
        @_combo = 0
        @_poorNum++
    @_dispScore = ~~(@_score.toFixed())
    @_scoreLabel.reflect @_dispScore

  _getDigits : (num)-> Math.log(num) / Math.log(10) + 1 | 0

module.exports = StatsLayer
