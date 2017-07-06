{ create-element, DOM } = require \react
{ div, h1, input } = DOM

require "./style.scss"

module.exports = ->
  div { class-name: "main" },
    div {},
      input { type: "text", value: "Suche" }
