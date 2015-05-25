res =
  buttonImage : "res/button.png"
  nodeImage   : "res/node.png"
  noteWhiteImage : "res/note-white.png"
  noteBlackImage : "res/note-black.png"
  noteTurntableImage : "res/note-turntable.png"

resources = []

resources.push v for k, v of res

module.exports =
  res : res
  resources : resources
