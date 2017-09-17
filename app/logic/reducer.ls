{ pairs-to-obj } = require \prelude-ls
Fuse = require "fuse.js"


# Helper Functions


stations-searcher = { search: -> [] }
reset-fuzzy-searcher = (stations) ->
  stations-searcher := new Fuse stations, {
    keys: ["name", "waterBodyName"]
    id: "id"
    distance: 0
    findAllMatches: true
    shouldSort: true
    threshold: 0.3
  }


reset-stations = (state, stations) ->
  reset-fuzzy-searcher stations
  { ...state, stations }


find-station = (stations, id) ->
  stations.find (s) -> s.id == id


reset-measurements = (state, measurements) ->
  { ...state, measurements }


focus-search-input = (state) ->
  { ...state, input-has-focus: true }


blur-search-input = (state) ->
  { ...state, input-has-focus: false }


change-search-text = (state, search-text) ->
  { ...state, search-text }


reset-search-results = (state) ->
  ids = stations-searcher.search state.search-text
  search-results = state.stations.filter (s) -> s.id in ids
  { ...state, search-results }


reset-current-station-data = (state) ->
  if !state.selected-station
    state
  else
    set-current-station-data state, state.selected-station.id


set-current-station-data = (state, id) ->
  history.push-state {}, id, "\#station/#{id}"
  { ...state, selected-station: enhanced-station-data state, id }


enhanced-station-data = (state, id) ->
  measure-type-map = do
    Discharge: \discharges
    SeaLevel: \sea-levels
    Temperature: \temperatures
    Weather: \weather

  station = find-station state.stations, id
  measurements = state.measurements[id] || []
  last-sync-date = new Date measurements[0]? && new Date measurements[0].datetime
  sensors = do
    [{ name:measure-type-map[m.measurement-type], unit: m.unit, current: m } for m in measurements]

  { ...station, last-sync-date, sensors, weather: undefined }


expand-sensor = (state, name) ->
  sensors = do
    [(if sensor.name != name then sensor else { ...sensor, expanded: true }) for sensor in state.selected-station.sensors]
  { ...state, selected-station: { ...state.selected-station, sensors } }


station-history-loaded = (state, history) ->
  if !state.selected-station?
    state
  else
    sensors = [{ ...sensor, history: history[sensor.name] } for sensor in state.selected-station.sensors]
    { ...state, selected-station: { ...state.selected-station, sensors } }


unselect-station = (state) ->
  history.replace-state {}, "FlowFlow", "/"
  { ...state, selected-station: undefined }


toggle-station-star = (state, id) ->
  if id in [s.id for s in state.starred-stations]
    unstar-station state, id
  else
    star-station state, id


star-station = (state, id) ->
  station = find-station state.stations, id
  { ...state, starred-stations: [...state.starred-stations, station] }


unstar-station = (state, id) ->
  { ...state, starred-stations: state.starred-stations.filter (x) -> x.id != id }


persist-starred-station-ids = (state) ->
  ids = [id for { id } in state.starred-stations]
  local-storage.set-item \starred-station-ids, JSON.stringify ids
  state


reset-starred-stations-data = (state) ->
  ids = JSON.parse local-storage.get-item \starred-station-ids
  { ...state, starred-stations: [enhanced-station-data state, id for id in ids || []] }



# Reducer


initial-state = do
  stations: []
  measurements: []
  search-text: ""
  input-has-focus: false
  search-results: []
  selected-station: undefined
  starred-stations: []


module.exports = (state = initial-state, action) ->
  console.log action.type, state

  switch action.type

    case \STATIONS_LOADED
      reset-stations state, action.stations
        |> reset-search-results

    case \MEASUREMENTS_LOADED
      reset-measurements state, action.measurements
        |> reset-current-station-data
        |> reset-starred-stations-data

    case \SEARCHBOX_FOCUSED
      focus-search-input state

    case \SEARCHBOX_BLURRED
      blur-search-input state

    case \SEARCHBOX_TEXT_CHANGED
      change-search-text state, action.search-text
        |> reset-search-results

    case \STATION_SELECTED
      set-current-station-data state, action.id

    case \STATION_HISTORY_LOADED
      station-history-loaded state, action.history

    case \STATION_UNSELECTED
      unselect-station state

    case \STATION_STAR_TOGGLED
      toggle-station-star state, action.id
        |> persist-starred-station-ids

    case \SENSOR_EXPANDED
      expand-sensor state, action.name

    default
      state
