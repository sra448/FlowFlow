{ create-element, DOM } = require \react
{ create-store } = require \redux
{ render } = require \react-dom
{ Provider } = require \react-redux


reducer = require "./logic/reducer.ls"
ui = require "./views/main.ls"


store = create-store reducer
app = create-element Provider, { store }, ui {}


render app, document.get-element-by-id \agua
