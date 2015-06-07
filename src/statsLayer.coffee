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

    @_judgement.init()


    @_scoreLabel.init @_getDigits(maxScore), 0
    @_scoreLabel.x = @_skin.score.x
    @_scoreLabel.y = @_skin.score.y
    #@_pgreatLabel = new cc.LabelTTF '   0', "Arial", 6, cc.size(40, 0), cc.TEXT_ALIGNMENT_LEFT
    @_pgreatLabel.init 4, 0
    @_pgreatLabel.x = @_skin.pgreatNum.x
    @_pgreatLabel.y = @_skin.pgreatNum.y
    #@_greatLabel = new cc.LabelTTF '   0', "Arial", 6, cc.size(40, 0), cc.TEXT_ALIGNMENT_LEFT
    @_greatLabel.init 4, 0
    @_greatLabel.x = @_skin.greatNum.x
    @_greatLabel.y = @_skin.greatNum.y


    #@_goodLabel = new cc.LabelTTF '   0', "Arial", 6, cc.size(40, 0), cc.TEXT_ALIGNMENT_LEFT
    @_goodLabel.init 4, 0
    @_goodLabel.x = @_skin.goodNum.x
    @_goodLabel.y = @_skin.goodNum.y


    #@_badLabel = new cc.LabelTTF '   0', "Arial", 6, cc.size(40, 0), cc.TEXT_ALIGNMENT_LEFT
    @_badLabel.init 4, 0
    @_badLabel.x = @_skin.badNum.x
    @_badLabel.y = @_skin.badNum.y


    #@_poorLabel = new cc.LabelTTF '   0', "Arial", 6, cc.size(40, 0), cc.TEXT_ALIGNMENT_LEFT
    @_poorLabel.init 4, 0
    @_poorLabel.x = @_skin.poorNum.x
    @_poorLabel.y = @_skin.poorNum.y


    @_comboLabel.init 4, 0
    @_comboLabel.x = @_skin.comboNum.x
    @_comboLabel.y = @_skin.comboNum.y


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
        #@_pgreatLabel.setString "   #{@_pgreatNum}"
        @_pgreatLabel.reflect @_pgreatNum
        @_judgement.show 0, 0, 1

      when "great"
        @_score += @_greatIncVal
        @_combo++
        @_greatNum++
        #@_greatLabel.setString "   #{@_greatNum}"
        @_greatLabel.reflect @_greatNum
        @_judgement.show 0, 0, 0.5

      when "good"
        @_score += @_goodIncVal
        @_combo++
        @_goodNum++
        #@_goodLabel.setString "   #{@_goodNum}"
        @_goodLabel.reflect @_goodNum
        @_judgement.show 1, 0, 0.5

      when "bad"
        @_combo = 0
        @_badNum++
        #@_badLabel.setString "   #{@_badNum}"
        @_badLabel.reflect @_badNum
        @_judgement.show 2, 0, 0.5

      else
        @_combo = 0
        @_poorNum++
        #@_poorLabel.setString "   #{@_poorNum}"
        @_poorLabel.reflect @_poorNum
        @_judgement.show 3, 0, 0.5

    if @_combo > @_maxCombo
      @_maxCombo = @_combo
      @_comboLabel.reflect @_maxCombo

    @_dispScore = ~~(@_score.toFixed())
    @_scoreLabel.reflect @_dispScore

  _getDigits : (num)-> Math.log(num) / Math.log(10) + 1 | 0

module.exports = StatsLayer
