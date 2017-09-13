{ connect } = require \react-redux
{ create-element, DOM } = require \react
{ div, h1, input } = DOM

search-ui = require "./search.ls"
detail-ui = require "./detail.ls"



# Styles


require "./styles/base.scss"
require "./styles/search.scss"
require "./styles/detail.scss"



# React Redux Bindings


map-state-to-props = ({ selected-station }) ->
  { selected-station }



# Main Component


main = ({ selected-station }) ->
  div { class-name: "main" },
    create-element search-ui, {}
    create-element detail-ui, {} if selected-station?



# Connected Component


module.exports = main |> connect map-state-to-props
