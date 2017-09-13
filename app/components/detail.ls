{ connect } = require \react-redux
{ create-element, DOM } = require \react
{ div, a, b, img, h1, strong } = DOM


icons =
  back: require "./icons/back.svg"
  star: require "./icons/star.svg"
  star-empty: require "./icons/star-empty.svg"
  type:
    Discharge: require "./icons/drain.svg"
    SeaLevel: require "./icons/level.svg"
    Temperature: require "./icons/temperatur.svg"
  weather:
    sun: require "./icons/sun.svg"
    sun-cloud: require "./icons/cloud-sun.svg"
    cloud: require "./icons/cloud.svg"
    rain: require "./icons/rain.svg"



# React Redux Bindings


map-state-to-props = ({ selected-station, starred-station-ids }) ->
  is-starred = selected-station && selected-station.id in starred-station-ids
  { selected-station, is-starred }


map-dispatch-to-props = (dispatch) ->
  on-back: ->
    dispatch { type: \STATION_UNSELECTED }
  on-toggle-star: (id) -> ->
    dispatch { type: \STATION_STAR_TOGGLED, id }



# Components


header = ({ selected-station, is-starred, on-back, on-toggle-star }) ->
  div { class-name: "header" },
    a { on-click: on-back },
      img { src: icons.back }
    div {},
      div { class-name: "station-name" }, selected-station.name
      div {}, selected-station.water-body-name
    a { on-click: on-toggle-star selected-station.id },
      img { src: if is-starred then icons.star else icons.star-empty }


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



# Main Component


main = ({ selected-station, is-starred, on-back, on-toggle-star }) ->
  sync-date = new Date selected-station.measurements[0].datetime

  div { class-name: "detail" },
    div { class-name: "spacer" } if window.navigator.standalone
    header { selected-station, on-back, on-toggle-star, is-starred }
    div { class-name: "infos" },
      for m in selected-station.measurements
        div {key: m.measurement-type},
          measurement-box { ...m, key: m.measurement-type }

      if selected-station.weather
        weather-box selected-station.weather

      div { class-name: "small" },
        sync-date.toLocaleString()



# Connected Component


module.exports = main |> connect map-state-to-props, map-dispatch-to-props
