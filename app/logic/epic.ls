{ Observable } = require \rxjs
{ combine-epics } = require \redux-observable


backend-url = "https://waterbuddy.herokuapp.com/api"


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



fetch-weather = (action$) ->
  action$
    .of-type \STATION_SELECTED
    .switch-map ({ id }) ->
      Observable
        .ajax
        .get "#{backend-url}/station/#{id}/weather"
        .retry 5
        .map ({ response }) ->
          { type: \STATION_WEATHER_LOADED, weather: response }


fetch-history = (action$) ->
  action$
    .of-type \STATION_SELECTED
    .switch-map ({ id }) ->
      Observable
        .ajax
        .get "#{backend-url}/station/#{id}/history"
        .retry 5
        .map ({ response }) ->
          { type: \STATION_HISTORY_LOADED, history: response }


module.exports = combine-epics back-button-triggered, fetch-weather, fetch-history
