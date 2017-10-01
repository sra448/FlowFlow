{ render } = require \react-dom
{ app, store } = require "./app.ls"


# kick off things

# debugger
render (app {}), document.get-element-by-id \app
store.dispatch { type: \APP_LOADED }



# register app as a PWA

if navigator.service-worker
  navigator
    .service-worker
    .register "./service-worker.js"
