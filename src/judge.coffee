Judge = cc.Class.extend
  ctor : (@_config)->
    console.dir @_config

  exec : (diffTime)->
    return "pgreat" if -@_config.pgreat < diffTime < @_config.pgreat
    return "great"  if -@_config.great  < diffTime < @_config.great
    return "good"   if -@_config.good   < diffTime < @_config.good
    return "bad"    if -@_config.bad    < diffTime < @_config.bad
    return "poor"

module.exports = Judge
