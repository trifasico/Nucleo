'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';
const RESOURCES = {
  "version.json": "ce8518075066e3dd94181c629ee3050c",
"index.html": "b347c320f0e67fa8fa3c933b48e01e10",
"/": "b347c320f0e67fa8fa3c933b48e01e10",
"main.dart.js": "e6f791ffd0b914c9ed23f8ba19a3d938",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"manifest.json": "bbdd56b744fbac7bf1daef57e8e14daa",
"assets/AssetManifest.json": "2b1324c00f9c4c7dc0ea93918c907527",
"assets/NOTICES": "ccca6ad0a74f64faa7338194fb6b2dc3",
"assets/FontManifest.json": "7b2a36307916a9721811788013e65289",
"assets/packages/youtube_player_flutter/assets/speedometer.webp": "50448630e948b5b3998ae5a5d112622b",
"assets/packages/flutter_inappwebview/t_rex_runner/t-rex.css": "5a8d0222407e388155d7d1395a75d5b9",
"assets/packages/flutter_inappwebview/t_rex_runner/t-rex.html": "16911fcc170c8af1c5457940bd0bf055",
"assets/fonts/MaterialIcons-Regular.otf": "1288c9e28052e028aba623321f7826ac",
"assets/assets/images/86619.jpeg": "4894df9937066fb82452f0a0fb8f6054",
"assets/assets/images/Icon.png": "d0e256e4531390ab885ac9089c5ef53a",
"assets/assets/images/Icon.jpg": "955f0638f962589cb47f5824ebd97960",
"assets/assets/images/83564.jpeg": "751a48b956d346fa7b62bc865af7275e",
"assets/assets/images/85632.jpeg": "affc826ad245e466355b81d4592d8ae7",
"assets/assets/images/JEE21Alto.png": "904a936535117ab61f32a5394cee2b1c",
"assets/assets/images/JEE21.png": "155bf0c731e69a9341b99152cc36d5a4",
"assets/assets/images/88299.jpeg": "32c7e7e72594a2568bbd72ef42fa47aa",
"assets/assets/images/85951.jpeg": "bc6f0c918e4442fc4a9761629d66ed2a",
"assets/assets/images/88230.jpeg": "64f68b8e281ea784181e77171a2215e8",
"assets/assets/images/88288.jpeg": "c55915c646e207c5df314dffd3f0a975",
"assets/assets/images/85156.jpeg": "7c32895ad19488581d731c289a567ab6",
"assets/assets/images/86055.jpeg": "9c105ea4086875240a1972cd426441a8",
"assets/assets/images/IconNEEEICUM.png": "d0e256e4531390ab885ac9089c5ef53a",
"assets/assets/images/82562.jpeg": "6ce20dd240360a8115821eb8d312328a",
"assets/assets/images/wifiNo.png": "efcf27abbf06dd87781339c971635e7c",
"assets/assets/images/88245.jpeg": "2ecf2dd76950f858fb3c4148b5bea19f",
"assets/assets/images/PickleRick.jpg": "783425a89e5870d0b09e4067f6eab88b",
"assets/assets/images/80946.jpeg": "68dca6a35741ef4d362e9466783ac3a1",
"assets/assets/images/84139.jpeg": "eda92a0567a2b186b28498606c76d30f",
"assets/assets/images/Base.png": "4a1ce7a22c1a4f2901d7be4be38a8a33",
"assets/assets/images/78006.jpeg": "b05768d95d4f1d3dd8446e1a899460d3",
"assets/assets/images/88244.jpeg": "009f5d43ba6769978e697c6e1351f8a8",
"assets/assets/images/88222.jpeg": "a57c8c6253907735164126b0d1589b13",
"assets/assets/images/84978.jpeg": "0b9b47e614ca0424b91bd4112900b6f5",
"assets/assets/images/86362.jpeg": "04344d8efdbc67b10956142ba042433c",
"assets/assets/images/80541.jpeg": "1b13697136d87a7ea78cf31571f93b41",
"assets/assets/images/88258.jpeg": "6353d778188438200adb88cf5a22a057",
"assets/assets/images/Bas.jpeg": "acae0f5f646de203ac9ef2a5793785fd"
};

// The application shell files that are downloaded before a service worker can
// start.
const CORE = [
  "/",
"main.dart.js",
"index.html",
"assets/NOTICES",
"assets/AssetManifest.json",
"assets/FontManifest.json"];
// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value + '?revision=' + RESOURCES[value], {'cache': 'reload'})));
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
        // lazily populate the cache.
        return response || fetch(event.request).then((response) => {
          cache.put(event.request, response.clone());
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
