{ create-element } = require \react
{ create-store, apply-middleware } = require \redux
{ Provider } = require \react-redux
{ create-epic-middleware } = require \redux-observable


reducer = require "./logic/reducer.ls"
epic = require "./logic/epic.ls"
ui = require "./components/main.ls"


epic-middleware = create-epic-middleware epic
store = create-store reducer, apply-middleware epic-middleware


module.exports = { store, app: -> create-element Provider, { store }, (create-element ui, {}) }
