res =
  buttonImage : "res/button.png"
  nodeImage   : "res/node.png"


resources = []

resources.push v for k, v of res

module.exports =
  res : res
  resources : resources
