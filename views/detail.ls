{ connect } = require \react-redux
{ create-element, DOM } = require \react
{ div, a, b, img, h1, strong } = DOM


icons =
  back: require "./icons/back.svg"
  type:
    Discharge: require "./icons/drain.svg"
    SeaLevel: require "./icons/level.svg"
    Temperature: require "./icons/temperatur.svg"
  weather:
    sun: require "./icons/sun.svg"
    sun-cloud: require "./icons/cloud-sun.svg"
    cloud: require "./icons/cloud.svg"
    rain: require "./icons/rain.svg"


map-state-to-props = ({ selected-station }) ->
  { selected-station }


map-dispatch-to-props = (dispatch) ->
  on-back: ({ target }) ->
    dispatch { type: \UNSELECT_STATION }


random-between = (a, b) ->
  Math.floor (Math.random() * (b - a)) + a


header = ({ selected-station, on-back }) ->
  div { class-name: "header" },
    a { on-click: on-back },
      img { src: icons.back }
    div { class-name: "station-name" }, selected-station.name
    div {}, selected-station.water-body-name


weather-box = ({ air-temp, indicator }) ->
  div { class-name: "infobox" },
    div {},
      b {}, air-temp
      div {},
        img { src: icons.weather[indicator] }
        div { class-name: "small" }, indicator


measurement-box = ({ measurement-type, value, unit }) ->
  div { class-name: "infobox" },
    div {},
      b {}, value
      div {},
        img { src: icons.type[measurement-type] }
        div { class-name: "small" }, measurement-type
        div {}, unit


module.exports = do
  connect map-state-to-props, map-dispatch-to-props <|
    ({ selected-station, on-back }) ->
      if !selected-station
        div {}
      else
        sync-date = new Date selected-station.measurements[0].datetime

        div { class-name: "detail" },
          header { selected-station, on-back }

          div { class-name: "infos" },
            for m in selected-station.measurements
              div {key: m.measurement-type},
                measurement-box { ...m, key: m.measurement-type }

            if selected-station.weather
              weather-box selected-station.weather

            div { class-name: "small" },
              sync-date.toLocaleString()
