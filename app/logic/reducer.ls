
initial-state = do
  selected-station: undefined
  stations:
    1000: "Reuss"
    2000: "Aare"
    3000: "Rhein"


select-station = (state, station) ->
  { ...state, selected_station: station }


module.exports = (state = initial-state, action) ->
  switch action.type
    case \SELECT_STATION then select-station state, action.id
    default state
