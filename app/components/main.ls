{ connect } = require \react-redux
{ create-element, DOM } = require \react
{ div, span } = DOM

search-ui = require "./search.ls"
detail-ui = require "./detail.ls"



# Styles


require "./styles/base.scss"
require "./styles/search.scss"
require "./styles/detail.scss"



# React Redux Bindings


map-state-to-props = ({ selected-station, flash-show, flash-message }) ->
  { selected-station, flash-show, flash-message }



# Main Component


main = ({ selected-station, flash-message, flash-show }) ->
  div { class-name: "main" },
    create-element search-ui, {}
    create-element detail-ui, {} if selected-station?
    if flash-message?
      div { class-name: "flash #{"visible" if flash-show}" },
        span {}, flash-message



# Connected Component


module.exports = main |> connect map-state-to-props
