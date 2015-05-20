(function() {
  var Timer;

  Timer = cc.Class.extend({
    ctor: function() {
      this._super();
      this._startTime = 0;
      return this._pauseTime = 0;
    },
    start: function() {
      return this._startTime = new Date();
    },
    get: function() {
      if (this._startTime) {
        return ((new Date() - this._startTime) + this._pauseTime) / 1000;
      } else {
        return 0;
      }
    },
    pause: function() {
      return this._pauseTime = new Date() - this._startTime;
    },
    stop: function() {
      this._startTime = 0;
      return this._pauseTime = 0;
    }
  });

  module.exports = Timer;

}).call(this);
