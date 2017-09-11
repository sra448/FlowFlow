/******/ (function(modules) { // webpackBootstrap
/******/ 	// The module cache
/******/ 	var installedModules = {};
/******/
/******/ 	// The require function
/******/ 	function __webpack_require__(moduleId) {
/******/
/******/ 		// Check if module is in cache
/******/ 		if(installedModules[moduleId]) {
/******/ 			return installedModules[moduleId].exports;
/******/ 		}
/******/ 		// Create a new module (and put it into the cache)
/******/ 		var module = installedModules[moduleId] = {
/******/ 			i: moduleId,
/******/ 			l: false,
/******/ 			exports: {}
/******/ 		};
/******/
/******/ 		// Execute the module function
/******/ 		modules[moduleId].call(module.exports, module, module.exports, __webpack_require__);
/******/
/******/ 		// Flag the module as loaded
/******/ 		module.l = true;
/******/
/******/ 		// Return the exports of the module
/******/ 		return module.exports;
/******/ 	}
/******/
/******/
/******/ 	// expose the modules object (__webpack_modules__)
/******/ 	__webpack_require__.m = modules;
/******/
/******/ 	// expose the module cache
/******/ 	__webpack_require__.c = installedModules;
/******/
/******/ 	// identity function for calling harmony imports with the correct context
/******/ 	__webpack_require__.i = function(value) { return value; };
/******/
/******/ 	// define getter function for harmony exports
/******/ 	__webpack_require__.d = function(exports, name, getter) {
/******/ 		if(!__webpack_require__.o(exports, name)) {
/******/ 			Object.defineProperty(exports, name, {
/******/ 				configurable: false,
/******/ 				enumerable: true,
/******/ 				get: getter
/******/ 			});
/******/ 		}
/******/ 	};
/******/
/******/ 	// getDefaultExport function for compatibility with non-harmony modules
/******/ 	__webpack_require__.n = function(module) {
/******/ 		var getter = module && module.__esModule ?
/******/ 			function getDefault() { return module['default']; } :
/******/ 			function getModuleExports() { return module; };
/******/ 		__webpack_require__.d(getter, 'a', getter);
/******/ 		return getter;
/******/ 	};
/******/
/******/ 	// Object.prototype.hasOwnProperty.call
/******/ 	__webpack_require__.o = function(object, property) { return Object.prototype.hasOwnProperty.call(object, property); };
/******/
/******/ 	// __webpack_public_path__
/******/ 	__webpack_require__.p = "";
/******/
/******/ 	// Load entry module and return exports
/******/ 	return __webpack_require__(__webpack_require__.s = 199);
/******/ })
/************************************************************************/
/******/ ({

/***/ 199:
/***/ (function(module, exports) {

var PRECACHE, RUNTIME, PRECACHE_URLS;
PRECACHE = 'flowflow-v1.0.1';
RUNTIME = "prod";
PRECACHE_URLS = ["index.html", "index.js", "https://fonts.googleapis.com/css?family=Lobster+Two:400,700i"];
self.addEventListener("install", function(event){
  return event.waitUntil(caches.open(PRECACHE).then(function(cache){
    return cache.addAll(PRECACHE_URLS);
  }).then(self.skipWaiting()));
});
self.addEventListener("activate", function(event){
  var currentCaches;
  currentCaches = [PRECACHE, RUNTIME];
  return event.waitUntil(caches.keys().then(function(cacheNames){
    return cacheNames.filter(function(cacheName){
      return !currentCaches.includes(cacheName);
    });
  }).then(function(cachesToDelete){
    return Promise.all(cachesToDelete.map(function(cachesToDelete){
      return caches['delete'](cachesToDelete);
    }));
  }).then(function(){
    return self.clients.claim();
  }));
});
self.addEventListener('fetch', function(event){
  console.log("fetch");
  return event.respondWith(caches.match(event.request).then(function(cachedResponse){
    if (cachedResponse) {
      console.log("this is cached");
      return cachedResponse;
    } else {
      return caches.open(RUNTIME).then(function(cache){
        return fetch(event.request).then(function(response){
          console.log("put that ting in the cache");
          return cache.put(event.request, response.clone()).then(function(){
            return response;
          });
        });
      });
    }
  }));
});
//# sourceMappingURL=/Users/flo/Projects/agua/node_modules/livescript-loader/index.js!/Users/flo/Projects/agua/service-worker.ls.map


/***/ })

/******/ });