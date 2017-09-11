{ repeat } = require \prelude-ls
{ connect } = require \react-redux
{ create-element, DOM } = require \react
{ div, h1, input, ul, li, img, svg, path, strong } = DOM

search-icon = require "./icons/search.svg"


map-state-to-props = ({ search-text, search-results, input-has-focus }) ->
  { search-text, search-results, input-has-focus }

map-dispatch-to-props = (dispatch) ->
  on-focus: ->
    dispatch { type: \FOCUS_SEARCH_INPUT }
  on-blur: ->
    dispatch { type: \BLUR_SEARCH_INPUT }
  on-change: ({ target }) ->
    dispatch { type: \CHANGE_SEARCH_TEXT, search-text: target.value }
  on-select-station: (id) -> ->
    dispatch { type: \SELECT_STATION, id }


wavey-line = ->
  svg { height: 18, width: "100%" },
    path {
      d: "M 0 4 #{repeat 24, "q 4 -4 8 0 q 4 4 8 0" }"
      stroke: "white"
      stroke-width: "1"
      fill: "transparent"
    }


module.exports = do
  connect map-state-to-props, map-dispatch-to-props <|
    ({ search-text, search-results, input-has-focus, on-change, on-select-station, on-focus, on-blur }) ->
      show-as-condensed = input-has-focus || search-results.length > 0

      div { class-name: "search #{"condensed" if show-as-condensed}" },
        h1 {}, "FlowFlow"
        div { class-name: "textbox" },
          div {},
            input { on-focus, on-change, on-blur, type: "text", value: search-text, placeholder: "River or Lake" }
            img { src: search-icon }
          wavey-line {}
        ul {},
          for { id, name, water_body_name } in search-results
            li { key: id, on-click: on-select-station id },
              "#{water_body_name}, #{name}"
