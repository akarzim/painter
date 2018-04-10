document.addEventListener('DOMContentLoaded', function(){
  var lazyImages = [].slice.call(document.querySelectorAll(".lazy"));

  if ("IntersectionObserver" in window) {
    let lazyImageObserver = new IntersectionObserver(function(entries) {
      entries.forEach(function(entry) {
        if (entry.isIntersecting) {
          let lazyImage = entry.target;
          if (lazyImage.dataset.src){ lazyImage.src = lazyImage.dataset.src; }
          if (lazyImage.dataset.srcset){ lazyImage.srcset = lazyImage.dataset.srcset;}
          lazyImageObserver.unobserve(lazyImage);
        }
      });
    }, {
      rootMargin: "100%"
    });

    lazyImages.forEach(function(lazyImage) {
      lazyImageObserver.observe(lazyImage);
    });
  } else {
    // Possibly fall back to a more compatible method here
  }
});
