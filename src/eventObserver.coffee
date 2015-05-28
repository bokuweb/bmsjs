EventObserver = cc.Class.extend

  ctor : ->
    @_listeners = []

  on: (name, callback, params)->
    @_listeners.push
      name: name
      callback: callback
      params : params

  trigger: (name, data)->
    for listener in @_listeners when listener.name is name
      listener.callback name, data, listener.params
    return

module.exports = EventObserver
