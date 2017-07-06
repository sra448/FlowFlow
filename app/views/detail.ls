{ connect } = require \react-redux
{ create-element, DOM } = require \react
{ div, a, b, img } = DOM

back-icon = require "./icons/back.svg"
drain-icon = require "./icons/drain.svg"
level-icon = require "./icons/level.svg"
temperatur-icon = require "./icons/temperatur.svg"
wheater-icon = require "./icons/wheater.svg"


map-state-to-props = ({ selected-station }) ->
  { selected-station }

map-dispatch-to-props = (dispatch) ->
  on-back: ({ target }) ->
    dispatch { type: \UNSELECT_STATION }


module.exports = do
  connect map-state-to-props, map-dispatch-to-props <|
    ({ selected-station, on-back }) ->
      if !selected-station
        div {}
      else
        div { class-name: "detail" },
          div { class-name: "header" },
            a { on-click: on-back },
              img { src: back-icon }
            selected-station

          div { class-name: "infobox" },
            b {}, "123"
            div {},
              img { src: drain-icon }
              "Abfluss"

          div { class-name: "infobox" },
            b {}, "560"
            div {},
              img { src: level-icon }
              "Wasserstand"

          div { class-name: "infobox" },
            b {}, "18"
            div {},
              img { src: temperatur-icon }
              "Temparatur"

          div { class-name: "footer" },
            div {}, "Stand, 07. Juli 2017"
            div {},
              img { src: wheater-icon }
