resObjs =
  bgImage : "res/bg.jpg"
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
  numeralImage : "res/number.png"
  turntableImage : "res/turntable.png"
  soundonlyImage : "res/sound-only.png"
  resultBgImage : "res/result-bg.jpg"
  menuBgImage : "res/menu-bg.jpg"
  itemBgImage : "res/item-bg.png"
  levelFontImage : "res/level-font.png"  

resList = []

resList.push v for k, v of resObjs
###
resList.push
  type : "font"
  name : "sapceage"
  srcs : ["res/fonts/spaceage.ttf"]
###
module.exports =
  resObjs : resObjs
  resList : resList
