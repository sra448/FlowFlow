module.exports = {
  entry: {
    "index": "./app/index.ls",
    "service-worker": "./app/service-worker.ls",
  },
  output: {
    path: __dirname,
    filename: "app/[name].js"
  },
  module: {
    loaders: [
      { test: /\.ls$/, loader: "livescript-loader" },
      { test: /\.svg$/, loader: "url-loader" },
      { test: /\.scss$/, loaders: ["style-loader", "css-loader", "sass-loader"] }
    ]
  }
}
