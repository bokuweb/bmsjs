(function() {
  var FallObj;

  FallObj = cc.Class.extend({
    ctor: function() {
      return this._super();
    },
    _calcSpeed: function(bpm, fallDistance) {
      var measureTime;
      measureTime = 240000 / bpm;
      return fallDistance / measureTime;
    },
    _appendFallParams: function(obj, bpms, time, fallDistance) {
      var diffDistance, i, j, k, l, len, len1, len2, m, previousBpm, ref, ref1, ref2, v;
      previousBpm = 0;
      obj.dstY = [];
      obj.index = 0;
      obj.speed = [];
      obj.bpm = {
        timing: [],
        val: []
      };
      for (i = j = 0, len = bpms.length; j < len; i = ++j) {
        v = bpms[i];
        if (!((time < (ref = v.timing) && ref < obj.timing))) {
          continue;
        }
        obj.bpm.timing.push(v.timing);
        obj.bpm.val.push(v.val);
      }
      if (bpms[0].timing > time) {
        previousBpm = bpms[0].val;
      } else {
        for (k = 0, len1 = bpms.length; k < len1; k++) {
          v = bpms[k];
          if (v.timing <= time) {
            previousBpm = v.val;
          }
        }
      }
      obj.dstY[obj.bpm.timing.length] = fallDistance;
      obj.bpm.timing.push(obj.timing);
      ref1 = obj.bpm.timing;
      for (i = l = ref1.length - 1; l >= 0; i = l += -1) {
        v = ref1[i];
        if (!(i < obj.bpm.timing.length - 1)) {
          continue;
        }
        diffDistance = (obj.bpm.timing[i + 1] - v) * this._calcSpeed(obj.bpm.val[i], fallDistance);
        obj.dstY[i] = obj.dstY[i + 1] - diffDistance;
      }
      obj.bpm.val.splice(0, 0, previousBpm);
      ref2 = obj.bpm.val;
      for (m = 0, len2 = ref2.length; m < len2; m++) {
        v = ref2[m];
        obj.speed.push(this._calcSpeed(v, fallDistance));
      }
    }
  });

  module.exports = FallObj;

}).call(this);
