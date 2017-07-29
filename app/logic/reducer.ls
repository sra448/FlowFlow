Fuse = require "fuse.js"
{ obj-to-pairs, map } = require "prelude-ls"


initial-state = do
  stations: []
  measurements: []
  search-text: ""
  search-results: []
  selected-station: undefined


stations-fuse = { search: -> [] }


load-stations = (state, stations) ->
  stations-fuse := new Fuse stations, { keys: ["name", "water_body_name"], id: "id", distance: 1 }
  { ...state, stations }


load-measurements = (state, measurements) ->
  { ...state, measurements }


change-search-text = (state, search-text) ->
  ids = stations-fuse.search search-text
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
    case \CHANGE_SEARCH_TEXT then change-search-text state, action.search-text
    case \SELECT_STATION then select-station state, action.id
    case \UNSELECT_STATION then unselect-station state
    default state
