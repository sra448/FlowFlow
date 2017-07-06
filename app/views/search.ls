{ connect } = require \react-redux
{ create-element, DOM } = require \react
{ div, h1, input, ul, li, img } = DOM

search-icon = require "./icons/search.svg"


map-state-to-props = ({ search-text, search-results }) ->
  { search-text, search-results }

map-dispatch-to-props = (dispatch) ->
  on-change: ({ target }) ->
    dispatch { type: \CHANGE_SEARCH_TEXT, search-text: target.value }
  on-select-station: (id) -> ->
    dispatch { type: \SELECT_STATION, id }


module.exports = do
  connect map-state-to-props, map-dispatch-to-props <|
    ({ search-text, search-results, on-change, on-select-station }) ->
      div { class-name: "search" },
        div {},
          input { on-change, type: "text", value: search-text, auto-focus: true }
          img { src: search-icon }
        ul {},
          for { id, name } in search-results
            li { on-click: on-select-station id }, name
