cc.game.onStart = ->
  AppScene = require './app'
  Parser   = require './parser'
  resList  = require './resource'
    .resList

  if not cc.sys.isNative and document.getElementById "cocosLoading"
    document.body.removeChild(document.getElementById "cocosLoading")

  cc.view.enableRetina off
  cc.view.adjustViewPort on
  cc.director.setContentScaleFactor 2
  height =  cc.view.getFrameSize().height / cc.view.getFrameSize().width * 320
  cc.view.setDesignResolutionSize 320, height, cc.ResolutionPolicy.SHOW_ALL
  cc.view.resizeWithBrowserSize on

  xhr = cc.loader.getXMLHttpRequest()
  xhr.timeout = 5000
  xhr.open 'GET', 'http://localhost:8000/bms/va.bms', true
  xhr.send()

  xhr.onreadystatechange = ->
    if xhr.readyState is 4 and 200 <= xhr.status <= 207
      console.log xhr.status
      res = xhr.responseText
      parser = new Parser()
      bms = parser.parse res
      resList.push 'bms/' + v for k, v of bms.wav

      cc.LoaderScene.preload resList, ->
        cc.director.runScene new AppScene bms, 'bms/'
      , this


cc.game.run()
