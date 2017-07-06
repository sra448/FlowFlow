{ connect } = require \react-redux
{ create-element, DOM } = require \react
{ div, h1, input, ul, li } = DOM


map-state-to-props = ({ search-text, search-results }) ->
  { search-text, search-results }

map-dispatch-to-props = (dispatch) ->
  on-change: ({ target }) ->
    dispatch { type: \CHANGE_SEARCH_TEXT, search-text: target.value }


module.exports = do
  connect map-state-to-props, map-dispatch-to-props <|
    ({ search-text, search-results, on-change }) ->
      div {},
        input { on-change, type: "text", value: search-text }
        ul {},
          for name in search-results
            li {}, name
