{ create-element, DOM } = require \react
{ div, h1 } = DOM

require "./style.scss"

module.exports = ->
  div { class-name: "main" },
    h1 {}, "make app here"
