{ Observable } = require \rxjs
{ combine-epics } = require \redux-observable


backend-url = "https://waterbuddy.herokuapp.com/api"


get = (url-fragment) ->
  Observable
    .ajax
    .get "#{backend-url}/#{url-fragment}"
    .retry 5


fetch-stations = (action$) ->
  action$
    .of-type \APP_LOADED
    .switch-map ({ id }) -> get "stations"
    .map ({ response }) ->
      { type: \STATIONS_LOADED, stations: response }


fetch-measurements = (action$) ->
  action$
    .of-type \APP_LOADED
    .switch-map ({ id }) -> get "measurements"
    .map ({ response }) ->
      { type: \MEASUREMENTS_LOADED, measurements: response }


back-button-triggered = (action$) ->
  action$
    .of-type \APP_LOADED
    .switch-map ->
      register = (h) -> window.onpopstate = h
      unregister = -> window.onpopstate = undefined
      Observable
        .from-event-pattern register, unregister
        .map ({ state }) ->
          { type: \STATION_UNSELECTED }


fetch-history = (action$) ->
  action$
    .of-type \STATION_SELECTED
    .switch-map ({ id }) -> get "station/#{id}/history"
    .map ({ response }) ->
      { type: \STATION_HISTORY_LOADED, history: response }


module.exports = do
  combine-epics do
    back-button-triggered,
    fetch-history,
    fetch-stations,
    fetch-measurements
