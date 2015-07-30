NumeralLayer   = require './numeralLayer'
JudgementLayer = require './judgementLayer'

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
    @_judgement = new JudgementLayer @_skin.judge
    @addChild @_scoreLabel
    @addChild @_pgreatLabel
    @addChild @_greatLabel
    @addChild @_goodLabel
    @addChild @_badLabel
    @addChild @_poorLabel
    @addChild @_comboLabel
    @addChild @_judgement

  init : (@_noteNum, maxScore) ->
    @_score = 0
    @_dispScore = 0
    @_maxCombo = 0
    @_combo = 0
    @_pgreatNum = 0
    @_greatNum = 0
    @_goodNum = 0
    @_badNum = 0
    @_poorNum = 0
    @_comboPoint = 0
    @_pgreatIncVal = maxScore.pgreat / @_noteNum
    @_greatIncVal = maxScore.great / @_noteNum
    @_goodIncVal = maxScore.good / @_noteNum
    @_comboBonusFactor = maxScore.combo / (10 * (@_noteNum - 1) - 55)
    @_incValonUpdate = maxScore.pgreat / @_noteNum / 2
    @_judgement.init()

    @_scoreLabel.init @_getDigits(maxScore.pgreat + maxScore.combo), 0
    @_scoreLabel.x = cc.screenSize.width / 2 + @_skin.score.x
    @_scoreLabel.y = cc.screenSize.height - @_skin.score.y
    #@_pgreatLabel = new cc.LabelTTF '   0', "Arial", 6, cc.size(40, 0), cc.TEXT_ALIGNMENT_LEFT
    @_pgreatLabel.init 4, 0
    @_pgreatLabel.x = cc.screenSize.width / 2 + @_skin.pgreatNum.x
    @_pgreatLabel.y = cc.screenSize.height - @_skin.pgreatNum.y
    #@_greatLabel = new cc.LabelTTF '   0', "Arial", 6, cc.size(40, 0), cc.TEXT_ALIGNMENT_LEFT
    @_greatLabel.init 4, 0
    @_greatLabel.x = cc.screenSize.width / 2 + @_skin.greatNum.x
    @_greatLabel.y = cc.screenSize.height - @_skin.greatNum.y
    #@_goodLabel = new cc.LabelTTF '   0', "Arial", 6, cc.size(40, 0), cc.TEXT_ALIGNMENT_LEFT
    @_goodLabel.init 4, 0
    @_goodLabel.x = cc.screenSize.width / 2 + @_skin.goodNum.x
    @_goodLabel.y = cc.screenSize.height - @_skin.goodNum.y
    #@_badLabel = new cc.LabelTTF '   0', "Arial", 6, cc.size(40, 0), cc.TEXT_ALIGNMENT_LEFT
    @_badLabel.init 4, 0
    @_badLabel.x = cc.screenSize.width / 2 + @_skin.badNum.x
    @_badLabel.y = cc.screenSize.height - @_skin.badNum.y
    #@_poorLabel = new cc.LabelTTF '   0', "Arial", 6, cc.size(40, 0), cc.TEXT_ALIGNMENT_LEFT
    @_poorLabel.init 4, 0
    @_poorLabel.x = cc.screenSize.width / 2 + @_skin.poorNum.x
    @_poorLabel.y = cc.screenSize.height - @_skin.poorNum.y
    @_comboLabel.init 4, 0
    @_comboLabel.x = cc.screenSize.width / 2 + @_skin.comboNum.x
    @_comboLabel.y = cc.screenSize.height - @_skin.comboNum.y

  get : ->
    score  : ~~(@_score.toFixed())
    combo  : @_maxCombo
    pgreat : @_pgreatNum
    great  : @_greatNum
    good   : @_goodNum
    bad    : @_badNum
    poor   : @_poorNum

  start : -> @scheduleUpdate()

  reflect : (judge) ->
    switch judge
      when "pgreat"
        @_score += @_pgreatIncVal
        @_combo++
        @_pgreatNum++
        #@_pgreatLabel.setString "   #{@_pgreatNum}"
        @_pgreatLabel.reflect @_pgreatNum
        @_judgement.show 0, 0, 1

      when "great"
        @_score += @_greatIncVal
        @_combo++
        @_greatNum++
        #@_greatLabel.setString "   #{@_greatNum}"
        @_greatLabel.reflect @_greatNum
        @_judgement.show 1, 0, 0.5

      when "good"
        @_score += @_goodIncVal
        @_combo++
        @_goodNum++
        #@_goodLabel.setString "   #{@_goodNum}"
        @_goodLabel.reflect @_goodNum
        @_judgement.show 2, 0, 0.5

      when "bad"
        @_score += @_comboBonusFactor * @_comboPoint
        @_combo = 0
        @_comboPoint = 0
        @_badNum++
        #@_badLabel.setString "   #{@_badNum}"
        @_badLabel.reflect @_badNum
        @_judgement.show 3, 0, 0.5

      else # poor or epoor
        @_score += @_comboBonusFactor * @_comboPoint
        @_combo = 0
        @_comboPoint = 0
        @_poorNum++
        #@_poorLabel.setString "   #{@_poorNum}"
        @_poorLabel.reflect @_poorNum
        @_judgement.show 4, 0, 0.5

    # full combo
    if @_combo is @_noteNum
      @_score += @_comboBonusFactor * @_comboPoint
      @_comboPoint = 0

    if 0 < @_combo <= 10
      @_comboPoint += @_combo - 1
    else if @_combo > 10
      @_comboPoint += 10

    if @_combo > @_maxCombo
      @_maxCombo = @_combo
      @_comboLabel.reflect @_maxCombo

    #@_dispScore = ~~(@_score.toFixed())
    #@_scoreLabel.reflect @_dispScore

  update : ->
    if @_dispScore < ~~(@_score.toFixed())
      @_dispScore += @_incValonUpdate
      @_dispScore = if @_dispScore > ~~(@_score.toFixed()) then ~~(@_score.toFixed()) else @_dispScore
      @_scoreLabel.reflect @_dispScore    

  _getDigits : (num)-> Math.log(num) / Math.log(10) + 1 | 0

module.exports = StatsLayer
