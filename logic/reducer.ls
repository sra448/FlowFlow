Fuse = require "fuse.js"
{ obj-to-pairs, map } = require "prelude-ls"


initial-state = do
  stations: []
  measurements: []
  search-text: ""
  input-has-focus: false
  search-results: []
  selected-station: undefined


load-stations = (state, stations) ->
  reset-fuzzy-searcher stations
  { ...state, stations }


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


load-measurements = (state, measurements) ->
  { ...state, measurements }


focus-search-input = (state) ->
  { ...state, input-has-focus: true }


blur-search-input = (state) ->
  { ...state, input-has-focus: false }


change-search-text = (state, search-text) ->
  ids = stations-searcher.search search-text
  search-results = state.stations.filter (s) -> s.id in ids
  { ...state, search-text, search-results }


select-station = (state, id) ->
  station = state.stations.find (s) -> s.id == id
  {
    ...state
    selected-station: {
      name: station.name
      water-body-name: station.water_body_name
      measurements: state.measurements[id]
    }
  }


unselect-station = (state) ->
  {
    ...state,
    search-text: "",
    search-results: [],
    selected-station: undefined
  }



module.exports = (state = initial-state, action) ->
  console.log state, action
  switch action.type
    case \STATIONS_LOADED then load-stations state, action.stations
    case \MEASUREMENTS_LOADED then load-measurements state, action.measurements
    case \FOCUS_SEARCH_INPUT then focus-search-input state
    case \BLUR_SEARCH_INPUT then blur-search-input state
    case \CHANGE_SEARCH_TEXT then change-search-text state, action.search-text
    case \SELECT_STATION then select-station state, action.id
    case \UNSELECT_STATION then unselect-station state
    default state
