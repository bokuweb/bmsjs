_ = require 'lodash'

SearchController = cc.Layer.extend
  ctor : (@_items) ->

  search : (txt) ->
    visibleItems = _.filter @_items, (item) ->
      item.title.search(txt) isnt -1

module.exports = SearchController
