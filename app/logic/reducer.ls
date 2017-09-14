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
  console.log "reset-measurements", measurements
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
  { ...state, selected-station: enhanced-station-data state, id }


enhanced-station-data = (state, id) ->
  station = find-station state.stations, id
  {
    ...station,
    measurements: state.measurements[id] || []
    weather: undefined
  }


station-weather-loaded = (state, weather) ->
  { ...state, selected-station: { ...state.selected-station, weather } }


unselect-station = (state) ->
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
  local-storage.set-item \starred-station-ids, [id for { id } in state.starred-stations]
  state


reset-starred-stations-data = (state) ->
  ids = local-storage.get-item \starred-station-ids
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

    case \STATION_WEATHER_LOADED
      station-weather-loaded state, action.weather

    case \STATION_UNSELECTED
      unselect-station state

    case \STATION_STAR_TOGGLED
      toggle-station-star state, action.id
        |> persist-starred-station-ids

    default
      state
