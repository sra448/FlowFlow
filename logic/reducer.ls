Fuse = require "fuse.js"
{ obj-to-pairs, map } = require "prelude-ls"


initial-state = do
  stations: []
  measurements: []
  search-text: ""
  input-has-focus: false
  search-results: []
  selected-station: undefined


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
  if state.selected-station
    set-current-station-data state, state.selected-station.id
  else
    state


set-current-station-data = (state, id) ->
  id = id || state.selected-station?.id
  station = state.stations.find (s) -> s.id == id

  if !station
    state
  else
    {
      ...state
      selected-station: {
        id: id
        name: station.name
        water-body-name: station.water-body-name
        measurements: state.measurements[id]
        weather: undefined
      }
    }


station-weather-loaded = (state, weather) ->
  { ...state, selected-station: { ...state.selected-station, weather } }


unselect-station = (state) ->
  { ...state, selected-station: undefined }



module.exports = (state = initial-state, action) ->
  switch action.type

    case \STATIONS_LOADED
      reset-stations state, action.stations
        |> reset-search-results

    case \MEASUREMENTS_LOADED
      reset-measurements state, action.measurements
        |> reset-current-station-data

    case \SEARCHBOX_FOCUSED
      focus-search-input state

    case \SEARCHBOX_BLURRED
      blur-search-input state

    case \SEARCHBOX_TEXT_CHANGED
      change-search-text state, action.search-text
        |> reset-search-results

    case \STATION_SELECTED
      set-current-station-data state, action.id

    case \STATION_WEATHER_LOADED
      station-weather-loaded state, action.weather

    case \STATION_UNSELECTED
      unselect-station state

    default
      state
