{ create-element } = require \react
{ create-store, apply-middleware } = require \redux
{ render } = require \react-dom
{ Provider } = require \react-redux
{ create-epic-middleware } = require \redux-observable


reducer = require "./logic/reducer.ls"
epic = require "./logic/epic.ls"
ui = require "./components/main.ls"


epic-middleware = create-epic-middleware epic
store = create-store reducer, apply-middleware epic-middleware
app = create-element Provider, { store }, (create-element ui, {})


# kick off things

render app, document.get-element-by-id \agua
store.dispatch { type: \APP_LOADED }


# register app as a PWA

if navigator.service-worker
  navigator
    .service-worker
    .register "./service-worker.js"
