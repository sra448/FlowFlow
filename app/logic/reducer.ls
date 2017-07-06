stations = require "./stations.json"
Fuse = require "fuse.js"
{ obj-to-pairs, map } = require "prelude-ls"


initial-state = do
  search-text: ""
  search-results: []
  selected-station: undefined


station-data = obj-to-pairs stations |> map ([id, name]) -> { id, name }
fuse = new Fuse(station-data, { keys: ["name"], id: "id", distance: 1 })


change-search-text = (state, search-text) ->
  search-results = fuse.search search-text |> map (id) -> { id, name: stations[id] }
  { ...state, search-text, search-results }


select-station = (state, id) ->
  { ...state, selected-station: stations[id] }


unselect-station = (state) ->
  {
    ...state,
    search-text: "",
    search-results: [],
    selected-station: undefined
  }



module.exports = (state = initial-state, action) ->
  switch action.type
    case \CHANGE_SEARCH_TEXT then change-search-text state, action.search-text
    case \SELECT_STATION then select-station state, action.id
    case \UNSELECT_STATION then unselect-station state
    default state
