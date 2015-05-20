(function() {
  var EventObserver, FallObj, MeasureNodes,
    bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty;

  EventObserver = require('./eventObserver');

  FallObj = require('./fallObj');

  MeasureNodes = (function(superClass) {
    extend(MeasureNodes, superClass);

    function MeasureNodes(_sys, _timer) {
      this._sys = _sys;
      this._timer = _timer;
      this._add = bind(this._add, this);
      this._index = 0;
      this._notifier = new EventObserver();
      this._nodes = [];
      this._genTime = [];
    }

    MeasureNodes.prototype.init = function(res, bpms, nodes) {
      var i, j, len, node, time, v;
      time = 0;
      this._nodes.length = 0;
      this._genTime.length = 0;
      for (i = j = 0, len = nodes.length; j < len; i = ++j) {
        v = nodes[i];
        node = this._sys.createSprite(res.nodeImage.width, res.nodeImage.height, res.nodeImage.src);
        node.timing = v.timing;
        node.x = res.nodeImage.x;
        node.y = res.nodeImage.y;
        this._appendFallParams(node, bpms, time, res.fallDist);
        this._genTime.push(time);
        time = this._getGenTime(node, res.fallDist);
        this._nodes.push(node);
      }
      return this._genTime;
    };

    MeasureNodes.prototype.start = function() {
      return this._scheduleId = this._sys.setScheduler(this._add);
    };

    MeasureNodes.prototype.stop = function() {
      return this._sys.clearScheduler(this._scheduleId);
    };

    MeasureNodes.prototype.addListener = function(name, listner) {
      return this._notifier.on(name, listner);
    };

    MeasureNodes.prototype._getGenTime = function(obj, fallDist) {
      var i, j, len, ref, v;
      ref = obj.dstY;
      for (i = j = 0, len = ref.length; j < len; i = ++j) {
        v = ref[i];
        if (v > 0) {
          return ~~(obj.bpm.timing[i] - (v / this._calcSpeed(obj.bpm.val[i], fallDist)));
        }
      }
      return 0;
    };

    MeasureNodes.prototype._add = function() {
      if (this._genTime[this._index] == null) {
        return;
      }
      if (!(this._genTime[this._index] <= this._timer.get())) {
        return;
      }
      this._sys.addChild(this._sys.getCurrentScene(), this._nodes[this._index]);
      this._sys.setScheduler(this._update.bind(this, this._nodes[this._index]), this._nodes[this._index]);
      return this._index++;
    };

    MeasureNodes.prototype._update = function(node) {
      var diffDist, diffTime, time;
      time = this._timer.get();
      while (time > node.bpm.timing[node.index]) {
        if (node.index < node.bpm.timing.length - 1) {
          node.index++;
        } else {
          break;
        }
      }
      diffTime = node.bpm.timing[node.index] - time;
      diffDist = diffTime * node.speed[node.index];
      node.y = node.dstY[node.index] - diffDist;
      if (node.y > node.dstY[node.index]) {
        this._sys.removeChild(this._sys.getCurrentScene(), node);
        return this._notifier.trigger('remove', time);
      }
    };

    return MeasureNodes;

  })(FallObj);

  module.exports = MeasureNodes;

}).call(this);
