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
    keys: ["name", "water_body_name"]
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


select-station = (state, id) ->
  reset-current-station-data {
    ...state
    selected-station: {
      id: id
    }
  }


reset-current-station-data = (state) ->
  id = state.selected-station?.id
  station = state.stations.find (s) -> s.id == id

  if !station
    state
  else
    {
      ...state
      selected-station: {
        id: id
        name: station.name
        water-body-name: station.water_body_name
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
    case \STATIONS_LOADED then reset-search-results reset-stations state, action.stations
    case \MEASUREMENTS_LOADED then reset-current-station-data reset-measurements state, action.measurements
    case \FOCUS_SEARCH_INPUT then focus-search-input state
    case \BLUR_SEARCH_INPUT then blur-search-input state
    case \CHANGE_SEARCH_TEXT then reset-search-results change-search-text state, action.search-text
    case \SELECT_STATION then select-station state, action.id
    case \STATION_WEATHER_LOADED then station-weather-loaded state, action.weather
    case \UNSELECT_STATION then unselect-station state
    default state
