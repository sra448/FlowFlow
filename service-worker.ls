PRECACHE = 'flowflow-v1.0.3'
RUNTIME = "prod"

PRECACHE_URLS = [
  "index.html",
  "index.js",
  "https://fonts.googleapis.com/css?family=Lobster+Two:400,700i"
]


self.addEventListener "install", (event) ->
  event.wait-until do
    caches.open PRECACHE
      .then (cache) -> cache.add-all PRECACHE_URLS
      .then self.skip-waiting()


self.addEventListener "activate", (event) ->
  current-caches = [PRECACHE, RUNTIME]
  event.wait-until do
    caches
      .keys()
      .then (cacheNames) ->
        cacheNames.filter (cacheName) -> !current-caches.includes cacheName
      .then (caches-to-delete) ->
        Promise.all caches-to-delete.map (caches-to-delete) ->
          caches.delete caches-to-delete
      .then -> self.clients.claim()


self.addEventListener 'fetch', (event) ->
  console.log "fetch"
  event.respond-with do
    (caches.match event.request).then (cached-response) ->
      if cached-response
        console.log "this is cached"
        cached-response
      else
        caches.open RUNTIME
          .then (cache) ->
            fetch event.request
              .then (response) ->
                # Put a copy of the response in the runtime cache.
                console.log "put that ting in the cache"
                cache.put event.request, response.clone()
                  .then -> response
