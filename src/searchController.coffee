_ = require 'lodash'

SearchController = cc.Layer.extend
  ctor : (@_items) ->

  search : (txt) ->
    visibleItems = _.filter @_items, (item) ->
      txt = txt.replace /[Ａ-Ｚａ-ｚ０-９]/g, (s)-> String.fromCharCode(s.charCodeAt(0) - 0xFEE0)
      re = new RegExp txt, "i"
      item.title.search(re) isnt -1

module.exports = SearchController
