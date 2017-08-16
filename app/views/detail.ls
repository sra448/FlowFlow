{ connect } = require \react-redux
{ create-element, DOM } = require \react
{ div, a, b, img, h1, strong } = DOM


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


random-between = (a, b) ->
  Math.floor (Math.random() * (b - a)) + a


measurement-box = ({ measurementType, value, unit }) ->
  div { class-name: "infobox" },
    div {},
      b {}, value
      div {},
        img { src: drain-icon }
        div {}, measurementType
        div {}, unit


module.exports = do
  connect map-state-to-props, map-dispatch-to-props <|
    ({ selected-station, on-back }) ->
      if !selected-station
        div {}
      else
        div { class-name: "detail" },
          h1 {}, "Waterbuddy"
          div { class-name: "header" },
            a { on-click: on-back },
              img { src: back-icon }
            div {}, selected-station.waterBodyName
            div {}, selected-station.name

          for m in selected-station.measurements
            measurement-box m
