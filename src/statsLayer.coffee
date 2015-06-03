NumeralLayer = require './numeralLayer'

StatsLayer = cc.Layer.extend
  ctor: (@_skin) ->
    @_super()
    @_scoreLabel = new NumeralLayer @_skin.score
    @_pgreatLabel =  new NumeralLayer @_skin.pgreatNum
    @_greatLabel =  new NumeralLayer @_skin.greatNum
    @_goodLabel =  new NumeralLayer @_skin.goodNum
    @_badLabel =  new NumeralLayer @_skin.badNum
    @_poorLabel =  new NumeralLayer @_skin.poorNum
    @_comboLabel =  new NumeralLayer @_skin.comboNum

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

    @_pgreatLabel.init 4, 0
    @_pgreatLabel.x = @_skin.pgreatNum.x
    @_pgreatLabel.y = @_skin.pgreatNum.y
    @addChild @_pgreatLabel

    @_greatLabel.init 4, 0
    @_greatLabel.x = @_skin.greatNum.x
    @_greatLabel.y = @_skin.greatNum.y
    @addChild @_greatLabel

    @_goodLabel.init 4, 0
    @_goodLabel.x = @_skin.goodNum.x
    @_goodLabel.y = @_skin.goodNum.y
    @addChild @_goodLabel

    @_badLabel.init 4, 0
    @_greatLabel.x = @_skin.badNum.x
    @_greatLabel.y = @_skin.badNum.y
    @addChild @_badLabel

    @_poorLabel.init 4, 0
    @_greatLabel.x = @_skin.poorNum.x
    @_greatLabel.y = @_skin.poorNum.y
    @addChild @_poorLabel

    @_comboLabel.init 4, 0
    @_greatLabel.x = @_skin.comboNum.x
    @_greatLabel.y = @_skin.comboNum.y
    @addChild @_comboLabel

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
        @_pgreatLabel.reflect @_pgreatNum

      when "great"
        @_score += @_greatIncVal
        @_combo++
        @_greatNum++
        @_greatLabel.reflect @_greatNum

      when "good"
        @_score += @_goodIncVal
        @_combo++
        @_goodNum++
        @_goodLabel.reflect @_goodNum

      when "bad"
        @_combo = 0
        @_badNum++
        @_badLabel.reflect @_badNum

      else
        @_combo = 0
        @_poorNum++
        @_poorLabel.reflect @_poorNum

    if @_combo > @_maxCombo
      @_maxCombo = @_combo
      @_comboLabel.reflect @_maxCombo

    @_dispScore = ~~(@_score.toFixed())
    @_scoreLabel.reflect @_dispScore

  _getDigits : (num)-> Math.log(num) / Math.log(10) + 1 | 0

module.exports = StatsLayer
