express = require \express
app = express()

http = (require \http).Server app
port = Number process.env.PORT || 8000


app.use express.static \app


http.listen port, ->
  console.log "server listening on port #{port}"
