resObjs =
  bgImage : "res/bg.png"
  buttonImage : "res/button.png"
  nodeImage   : "res/node.png"
  noteWhiteImage : "res/note-white.png"
  noteBlackImage : "res/note-black.png"
  noteTurntableImage : "res/note-turntable.png"
  noteBgImage : "res/note-bg.png"
  greatEffectImage : "res/great-effect.png"
  turntableKeydownImage : "res/turntable-keydown.png"
  whiteKeydownImage : "res/white-keydown.png"
  blackKeydownImage : "res/black-keydown.png"
  testImage : "res/test.png"
  meterImage : "res/gauge.png"
  numeralImage : "res/numeral-font.png"
  test : "res/va.txt"

resList = []

resList.push v for k, v of resObjs

module.exports =
  resObjs : resObjs
  resList : resList
