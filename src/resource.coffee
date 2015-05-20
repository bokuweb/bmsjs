res =
  buttonImage : "res/button.png"

resources = []

resources.push v for k, v of res

module.exports =
  res : res
  resources : resources
