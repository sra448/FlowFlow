CACHE_VERSION = 'flowflow-v1'
PRECACHE_URLS = [
  "index.html",
  "index.js"
]


self.addEventListener "install", (event) ->
  event.waitUntil do
    caches.open PRECACHE
      .then (cache) -> cache.add-all PRECACHE_URLS
      .then self.skip-waiting()


self.addEventListener "activate", (event) ->
  currentCaches = [PRECACHE, RUNTIME]
  event.waitUntil do
    caches
      .keys()
      .then (cacheNames) ->
        cacheNames.filter (cacheName) -> !currentCaches.includes cacheName
      .then (caches-to-delete) ->
        Promise.all caches-to-delete.map (caches-to-delete) ->
          caches.delete caches-to-delete
      .then -> self.clients.claim()


self.addEventListener 'fetch', (event) ->
  # Skip cross-origin requests, like those for Google Analytics.
  if event.request.url.startsWith self.location.origin
    event.respondWith do
      (caches.match event.request).then (cachedResponse) ->
        if cachedResponse
          cachedResponse
        else
          caches.open RUNTIME
            .then (cache) ->
              fetch event.request
            .then (response) ->
              # Put a copy of the response in the runtime cache.
              cache.put event.request, response.clone()
                .then -> response
