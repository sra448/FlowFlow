{ create-element, DOM } = require \react
{ create-store } = require \redux
{ render } = require \react-dom
{ Provider } = require \react-redux


backend-url = "https://waterbuddy.herokuapp.com/api"


reducer = require "./logic/reducer.ls"
ui = require "./views/main.ls"


store = create-store reducer
app = create-element Provider, { store }, ui {}


render app, document.get-element-by-id \agua


# load data

fetch "#{backend-url}/stations"
  .then (resp) -> resp.json()
  .then (stations) ->
    store.dispatch { type: \STATIONS_LOADED, stations }

fetch "#{backend-url}/measurements"
  .then (resp) -> resp.json()
  .then (measurements) ->
    store.dispatch { type: \MEASUREMENTS_LOADED, measurements }
