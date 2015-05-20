(function() {
  var AppLayer, AppScene, res;

  res = require('./resource').res;

  AppLayer = cc.Layer.extend({
    sprite: null,
    ctor: function() {
      this._super();
      return this._addKey();
    },
    _addKey: function() {
      var i, j, key;
      for (i = j = 0; j < 8; i = ++j) {
        key = new cc.Sprite(res.buttonImage);
        if (i === 7) {
          key.attr({
            x: 33,
            y: 32,
            id: 7
          });
        } else {
          key.attr({
            x: i * 32 + 97,
            y: i % 2 * 64 + 32,
            id: i
          });
        }
        this.addChild(key);
      }
    }
  });

  AppScene = cc.Scene.extend({
    onEnter: function() {
      var layer;
      this._super();
      layer = new AppLayer();
      return this.addChild(layer);
    }
  });

  module.exports = AppScene;

}).call(this);
