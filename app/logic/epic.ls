{ Observable } = require \rxjs
{ combine-epics } = require \redux-observable


backend-url = "https://waterbuddy.herokuapp.com/api"


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


module.exports = fetch-weather
