module.exports = [{
  entry: {
    "server": "./server/server.ls"
  },
  output: {
    path: __dirname,
    filename: "server/[name].js"
  },
  target: "node",
  module: {
    loaders: [
      { test: /\.ls$/, loader: "livescript-loader" },
      { test: /\.svg$/, loader: "url-loader" },
      { test: /\.scss$/, loaders: ["style-loader", "css-loader", "sass-loader"] }
    ]
  }
}, {
  entry: {
    "index": "./app/index.ls",
    "service-worker": "./app/service-worker.ls"
  },
  output: {
    path: __dirname,
    filename: "server/public/[name].js"
  },
  module: {
    loaders: [
      { test: /\.ls$/, loader: "livescript-loader" },
      { test: /\.svg$/, loader: "url-loader" },
      { test: /\.scss$/, loaders: ["style-loader", "css-loader", "sass-loader"] }
    ]
  }
}]
