{ repeat } = require \prelude-ls
{ connect } = require \react-redux
{ create-element, DOM } = require \react
{ div, h1, input, ul, li, img, svg, path, strong } = DOM

search-icon = require "./icons/search.svg"
x-icon = require "./icons/x.svg"



# React Redux Bindings


map-state-to-props = ({ search-text, search-results, input-has-focus, starred-stations }) ->
  { search-text, search-results, input-has-focus, starred-stations }


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



# Components


search-box = ({ value, on-focus, on-change, on-blur, on-clear }) ->
  div { class-name: "textbox" },
    div {},
      input { type: \text, placeholder: "River or Lake", value, on-focus, on-change, on-blur }

      if value == ""
        img { src: search-icon }
      else
        img { src: x-icon, on-click: on-clear }


wave = ->
  div { class-name: "wave" },
    svg {},
      path {
        d: "M 0 4 #{repeat 24, "q 4 -4 8 0 q 4 4 8 0" }"
        stroke: "white"
        stroke-width: "1"
        fill: "transparent"
      }


result-list = ({ search-results, on-select-station }) ->
  ul {},
    for { id, name, water-body-name } in search-results
      li { key: id, on-click: on-select-station id },
        "#{water-body-name}, #{name}"



# Main Component


main = (props) ->
  { on-change, on-focus, on-blur, on-clear, starred-stations } = props
  { search-text, search-results, input-has-focus, on-select-station } = props
  show-as-condensed = input-has-focus || search-results.length > 0
  class-name = "search #{"condensed" if show-as-condensed}"

  div { class-name },
    div { class-name: "spacer" } if window.navigator.standalone
    h1 {}, \FlowFlow
    search-box { value: search-text, on-focus, on-change, on-blur, on-clear }
    wave {}

    if search-results.length > 0
      result-list { search-results, on-select-station }
    else
      div {},
        for { water-body-name, name } in starred-stations
          div { class-name: "infobox" },
            div {}, "#{water-body-name}, #{name}"



# Connected Main Component


module.exports = main |> connect map-state-to-props, map-dispatch-to-props
