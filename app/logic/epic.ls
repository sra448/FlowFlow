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


flash-message-star-station = (action$, store) ->
  action$
    .of-type \STATION_STAR_TOGGLED
    .switch-map ->
      { selected-station, starred-stations } = store.get-state()

      message = if selected-station.id in [id for { id } in starred-stations]
        "added to favourites"
      else
        "removed from favourites"

      Observable.merge do
        (Observable.of { type: \FLASH_MESSAGE_SET, message }),
        ((Observable.of { type: \FLASH_MESSAGE_SHOW }).delay 100),
        ((Observable.of { type: \FLASH_MESSAGE_HIDE }).delay 800),
        (Observable.of { type: \FLASH_MESSAGE_UNSET }).delay 900


module.exports = do
  combine-epics do
    back-button-triggered,
    fetch-history,
    fetch-stations,
    fetch-measurements,
    flash-message-star-station
