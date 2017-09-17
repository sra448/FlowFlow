PRECACHE = 'flowflow-v1.0.16'
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
      .then (cache-names) ->
        cache-names.filter (cache-name) -> !current-caches.includes cache-name
      .then (caches-to-delete) ->
        Promise.all [caches.delete cache for cache in caches-to-delete]
      .then -> self.clients.claim()


self.addEventListener 'fetch', (event) ->
  event.respond-with do
    (caches.match event.request).then (cached-response) ->
      if cached-response
        cached-response
      else
        caches.open RUNTIME
          .then (cache) ->
            fetch event.request
              .then (response) ->
                cache.put event.request, response.clone()
                  .then -> response
