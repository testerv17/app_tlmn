'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/AssetManifest.bin": "32099ccb40b46f91c1d63e531bae0d10",
"assets/AssetManifest.json": "22e0410c50778ff9c6ccd1fd30006b45",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/fonts/MaterialIcons-Regular.otf": "634450c56ce41982ef48d4615e9342e0",
"assets/lib/icons/alm1.png": "81a48e0d51b3029c8d549d67e3d3b89e",
"assets/lib/icons/evid.png": "9907d06aefd20069d74a159a5e6251ab",
"assets/lib/icons/galeria-de-imagenes.png": "3682496b6bb48ca7d64242a08157019f",
"assets/lib/icons/gps2.png": "67d01df54cc500d4edc71bf25a6c7169",
"assets/lib/icons/marcador-de-alfiler.png": "a6049340aafc676ceedc35a8de41c9c6",
"assets/lib/icons/pin.png": "c3f17882094635bd7ac3be02d332f5e6",
"assets/lib/icons/producto.png": "303af7927880c44d267b1bb178ffbfa7",
"assets/lib/icons/rep2.png": "83482a2f7a8fe40289ec65c01bb0adad",
"assets/lib/icons/reporte-de-negocios%2520(1).png": "3c0d652c3c7e158c24c78729680aa382",
"assets/lib/images/caja2.png": "dacaf22af2f532d01cc3fe048afbb0ad",
"assets/lib/images/cajas.png": "c038374d73945455f97b3b0262ef6688",
"assets/lib/images/fotos2.png": "a9bdb24f1f03206fe19695e11c033b9f",
"assets/lib/images/galeria.png": "03fad063a85d0da6a9a639f16a8273e3",
"assets/lib/images/gps.png": "1750c439679e5dd640db92914ccde4d3",
"assets/lib/images/gps2.png": "338af3751f049a6b55f33b01cb0b91c1",
"assets/lib/images/portapapeles.png": "ded09f659bafe1ccc017c39b90a7d6f8",
"assets/lib/images/rep1.png": "8a1e9cee87c979fd141408df9d2b55b8",
"assets/lib/images/teclumnsSlogan.png": "1a4e032aedd04c860094956bced9b186",
"assets/lib/images/tt.png": "507c9203695ffe604cc3df423d882cfb",
"assets/NOTICES": "572f53800820a51ce698e6b9014fd271",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "89ed8f4e49bcdfc0b5bfc9b24591e347",
"assets/shaders/ink_sparkle.frag": "f8b80e740d33eb157090be4e995febdf",
"canvaskit/canvaskit.js": "59ed8478b398a8966eee147930f3d966",
"canvaskit/canvaskit.wasm": "ba3b08e372f83e58e73b6a2b3af066e0",
"canvaskit/chromium/canvaskit.js": "853c6cebea386c05aa9d954f11b2c1ca",
"canvaskit/chromium/canvaskit.wasm": "728d019b9c150450805fc77fad4947e5",
"canvaskit/skwasm.js": "95f16c6690f955a45b2317496983dbe9",
"canvaskit/skwasm.wasm": "24a978be19e4b8fe6a6766c4a2591b04",
"canvaskit/skwasm.worker.js": "51253d3321b11ddb8d73fa8aa87d3b15",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"flutter.js": "6b515e434cea20006b3ef1726d2c8894",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"index.html": "c55b3a69cd27611ef99002eaf73f25f4",
"/": "c55b3a69cd27611ef99002eaf73f25f4",
"main.dart.js": "1a7b49e2848d2be34d088662da6d06f0",
"manifest.json": "9c32f3ecb73230c907f7d35a3cb39cea",
"version.json": "3204274f3063e94d8ca386a8f09e0537"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"assets/AssetManifest.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
