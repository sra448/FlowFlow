{ repeat } = require \prelude-ls
{ connect } = require \react-redux
{ create-element, DOM } = require \react
{ div, h1, input, ul, li, img, svg, path, strong } = DOM

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
        h1 {}, "Waterbuddy"
        div {},
          input { on-change, type: "text", value: search-text, auto-focus: true }
          img { src: search-icon }
        svg { height: 18, width: "100%" },
          path {
            d: "M 0 4 #{repeat 24, "q 4 -4 8 0 q 4 4 8 0" }"
            stroke: "white"
            stroke-width: "1"
            fill: "transparent"
          }
        ul {},
          for { id, name, water_body_name } in search-results
            li { on-click: on-select-station id },
              strong {}, water_body_name
              " - #{name}"
