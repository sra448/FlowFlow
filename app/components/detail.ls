{ connect } = require \react-redux
{ create-element, DOM } = require \react
{ ComposedChart, XAxis, YAxis, Area, Line } = require \recharts
{ div, a, b, img, h1, strong, linear-gradient, defs, stop } = DOM


icons =
  back: require "./icons/back.svg"
  star: require "./icons/star.svg"
  star-empty: require "./icons/star-empty.svg"
  type:
    discharges: require "./icons/drain.svg"
    sealevels: require "./icons/level.svg"
    temperatures: require "./icons/temperatur.svg"
  weather:
    sun: require "./icons/sun.svg"
    sun_cloud: require "./icons/cloud-sun.svg"
    cloud: require "./icons/cloud.svg"
    rain: require "./icons/rain.svg"



# React Redux Bindings


map-state-to-props = ({ selected-station, starred-stations }) ->
  is-starred = selected-station && selected-station.id in [id for {id} in starred-stations]
  { selected-station, is-starred }


map-dispatch-to-props = (dispatch) ->
  on-back: ->
    dispatch { type: \STATION_UNSELECTED }
  on-toggle-star: (id) -> ->
    dispatch { type: \STATION_STAR_TOGGLED, id }
  on-expand-sensor: (name) -> ->
    dispatch { type: \SENSOR_EXPANDED, name }



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


measurement-box = ({ name, current, unit, history, on-click }) ->
  div { on-click, class-name: "infobox" },
    div { class-name: "current" },
      b {}, current.value
      div {},
        img { src: icons.type[name] }
        div { class-name: "small" }, name
        div {}, unit


measurement-box-enhanced = ({ name, current, unit, history }) ->
  div { class-name: "infobox" },
    div { class-name: "current" },
      b {}, current.value
      div {},
        img { src: icons.type[name] }
        div { class-name: "small" }, name
        div {}, unit
    history-chart { history } if history


history-chart = ({ history }) ->
  data = [{ ...h, date: +new Date h.datetime } for h in history]
  width = (document.get-elements-by-class-name "infobox")[0]?.offset-width

  div { class-name: "history" },
    create-element ComposedChart, { data, width, height: 100, margin: { left: 0, right: 0 } },
      defs {},
        linear-gradient { id:"gradient", x1:"0", y1:"0", x2:"0", y2:"1" },
          stop { offset: "5%", stop-color: "\#82e0f5", stop-opacity: 0.3 }
          stop { offset: "90%", stop-color: "\#82e0f5", stop-opacity: 0 }
      # create-element Line, { data-key: "weeklyAverage", stroke: "blue" }
      create-element Area, { data-key: "value", stroke: "white", fill-opacity: 1, fill: "url(\#gradient)" }


weather-box = ({ air-temp, indicator }) ->
  div { class-name: "infobox" },
    div {},
      b {}, air-temp
      div {},
        img { src: icons.weather[indicator] }
        div { class-name: "small" }, indicator



# Main Component


find-sensor = (sensors, sensor-name) ->
  sensors.find ({ name }) -> name == sensor-name


main = ({ selected-station, is-starred, on-back, on-toggle-star, on-expand-sensor }) ->
  sensors = [find-sensor selected-station.sensors, name for name in [\discharges, \temperatures]]
  weather-sensor = find-sensor selected-station.sensors, \weather

  div { class-name: "detail" },
    div { class-name: "spacer" } if window.navigator.standalone
    header { selected-station, on-back, on-toggle-star, is-starred }

    div { class-name: "infos" },
      for sensor in sensors when sensor?
        div { key: sensor.name },
          if sensor.expanded
            measurement-box-enhanced { ...sensor }
          else
            measurement-box { ...sensor, on-click: on-expand-sensor sensor.name }

      if weather-sensor?
        weather-box weather-sensor.current

      if selected-station.last-sync-date?
        div { class-name: "small" },
          selected-station.last-sync-date.toLocaleString()



# Connected Component


module.exports = main |> connect map-state-to-props, map-dispatch-to-props
