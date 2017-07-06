{ connect } = require \react-redux
{ create-element, DOM } = require \react
{ div, a } = DOM


map-state-to-props = ({ selected-station }) ->
  { selected-station }

map-dispatch-to-props = (dispatch) ->
  on-back: ({ target }) ->
    dispatch { type: \UNSELECT_STATION }


module.exports = do
  connect map-state-to-props, map-dispatch-to-props <|
    ({ selected-station, on-back }) ->
      if !selected-station
        div {}
      else
        div { class-name: "detail" },
          a { on-click: on-back }, "back"
          selected-station
