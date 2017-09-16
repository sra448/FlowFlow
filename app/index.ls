{ create-element, DOM } = require \react
{ create-store, apply-middleware } = require \redux
{ render } = require \react-dom
{ Provider } = require \react-redux
{ create-epic-middleware, combine-epics } = require \redux-observable


reducer = require "./logic/reducer.ls"
epic = require "./logic/epic.ls"
ui = require "./components/main.ls"


epic-middleware = create-epic-middleware epic
store = create-store reducer, apply-middleware epic-middleware
app = create-element Provider, { store }, (create-element ui, {})


render app, document.get-element-by-id \agua

# kick off things
store.dispatch { type: \APP_LOADED }


# load data
# TODO: maybe find a better place for this in an epic?

backend-url = "https://waterbuddy.herokuapp.com/api"


fetch "#{backend-url}/stations"
  .then (resp) -> resp.json()
  .then (stations) ->
    store.dispatch { type: \STATIONS_LOADED, stations }

fetch "#{backend-url}/measurements"
  .then (resp) -> resp.json()
  .then (measurements) ->
    store.dispatch { type: \MEASUREMENTS_LOADED, measurements }


# register this app as a PWA
if navigator.service-worker
  navigator
    .service-worker
    .register "./service-worker.js"
    .then -> console.log "Service Worker Registered"
