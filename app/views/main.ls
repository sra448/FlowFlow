{ create-element, DOM } = require \react
{ div, h1, input } = DOM

search-ui = require "./search.ls"
detail-ui = require "./detail.ls"

require "./style.scss"


module.exports = ->
  div { class-name: "main" },
    create-element search-ui, {}
    create-element detail-ui, {}
