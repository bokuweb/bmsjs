(function() {
  var k, res, resources, v;

  res = {
    buttonImage: "res/button.png"
  };

  resources = [];

  for (k in res) {
    v = res[k];
    resources.push(v);
  }

  module.exports = {
    res: res,
    resources: resources
  };

}).call(this);
