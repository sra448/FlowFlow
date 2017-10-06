express = require \express
{ render-to-string } = require \react-dom/server
{ app } = require "../app/app.ls"

api = express()
port = Number process.env.PORT || 8000
server = (require \http).Server api


api.use express.static "server/public"


api.get "/", (req, res) ->
  console.log "request ..."

  res.write '<!DOCTYPE html>'
  res.write '<title>FlowFlow</title>'
  res.write '<link href="https://fonts.googleapis.com/css?family=Lobster+Two:400,700i" rel="stylesheet">'
  res.write '<link rel="manifest" href="/manifest.json">'
  res.write '<meta name="viewport" content="width=200, initial-scale=1.0, maximum-scale=1.0">'
  res.write '<meta name="theme-color" content="#00b8e0"/>'
  res.write '<meta name="apple-mobile-web-app-title" content="FlowFlow" />'
  res.write '<meta name="apple-mobile-web-app-capable" content="yes">'
  res.write '<meta name="apple-mobile-web-app-status-bar-style" content="black-translucent" />'
  res.write "<div id='app'>"
  res.write render-to-string app {}
  res.write "</div>"
  res.write '<script src="index.js"></script>'
  res.end()


server.listen port, ->
  console.log "server listening on port #{port}"
