capture = (name)-> if window.callPhantom? then callPhantom {'screenshot': name}

module.exports =
  capture : capture

