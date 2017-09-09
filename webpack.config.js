module.exports = {
  entry: {
    "index": "./index.ls",
    "service-worker": "./service-worker.ls",
  },
  output: {
    path: __dirname,
    filename: "[name].js"
  },
  module: {
    loaders: [
      { test: /\.ls$/, loader: "livescript-loader" },
      { test: /\.svg$/, loader: "url-loader" },
      { test: /\.scss$/, loaders: ["style-loader", "css-loader", "sass-loader"] }
    ]
  }
}
