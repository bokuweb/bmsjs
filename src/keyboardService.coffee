EventObserver = require './eventObserver'

KeyboardService = cc.Layer.extend
  ctor : (@_timer)->
    @_super()
    @_notifier = new EventObserver()

  init : (config)->
    return false unless 'keyboard' of cc.sys.capabilities
    cc.eventManager.addListener
      event : cc.EventListener.KEYBOARD
      onKeyPressed : @_onKeyPressed.bind this
    , this
    true

  addListener : (key, listener, id)->
    @_notifier.on key, listener, id

  _onKeyPressed : (key, event)->
    @_notifier.trigger key, @_timer.get()

module.exports = KeyboardService
