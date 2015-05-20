res = require './resource'
  .res

AppLayer = cc.Layer.extend
  sprite : null
  ctor : ->
    @_super()
    @_addKey()
    
  _addKey : ->
    for i in [0...8]
      key = new cc.Sprite res.buttonImage
      if i is 7
        key.attr
          x  : 33
          y  : 32
          id : 7
      else
        key.attr
          x  : i * 32 + 97
          y  : i % 2 * 64 + 32
          id : i
      @addChild key
    return

AppScene = cc.Scene.extend
  onEnter:->
    @_super()
    layer = new AppLayer()
    @addChild layer

module.exports = AppScene
