{ repeat } = require \prelude-ls
{ connect } = require \react-redux
{ create-element, DOM } = require \react
{ div, h1, input, ul, li, img, svg, path, strong } = DOM

search-icon = require "./icons/search.svg"
x-icon = require "./icons/x.svg"


map-state-to-props = ({ search-text, search-results, input-has-focus }) ->
  { search-text, search-results, input-has-focus }

map-dispatch-to-props = (dispatch) ->
  on-focus: ->
    dispatch { type: \SEARCHBOX_FOCUSED }
  on-blur: ->
    dispatch { type: \SEARCHBOX_BLURRED }
  on-clear: ({ target }) ->
    dispatch { type: \SEARCHBOX_TEXT_CHANGED, search-text: "" }
  on-change: ({ target }) ->
    dispatch { type: \SEARCHBOX_TEXT_CHANGED, search-text: target.value }
  on-select-station: (id) -> ->
    dispatch { type: \STATION_SELECTED, id }


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
    ({ search-text, search-results, input-has-focus, on-change, on-select-station, on-focus, on-blur, on-clear }) ->
      show-as-condensed = input-has-focus || search-results.length > 0

      div { class-name: "search #{"condensed" if show-as-condensed}" },
        h1 {}, "FlowFlow"
        div { class-name: "textbox" },
          div {},
            input { on-focus, on-change, on-blur, type: "text", value: search-text, placeholder: "River or Lake" }

            if search-text == ""
              img { src: search-icon }
            else
              img { src: x-icon, on-click: on-clear }


          wavey-line {}
        ul {},
          for { id, name, water-body-name } in search-results
            li { key: id, on-click: on-select-station id },
              "#{water-body-name}, #{name}"
