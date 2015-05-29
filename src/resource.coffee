resObjs =
  buttonImage : "res/button.png"
  nodeImage   : "res/node.png"
  noteWhiteImage : "res/note-white.png"
  noteBlackImage : "res/note-black.png"
  noteTurntableImage : "res/note-turntable.png"
  greatEffectImage : "res/great-effect.png"
  
resList = []

resList.push v for k, v of resObjs

module.exports =
  resObjs : resObjs
  resList : resList
