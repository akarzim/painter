document.addEventListener('DOMContentLoaded', function(){
  let lazyImages = Array.prototype.slice.call(document.querySelectorAll(".lazy"));

  let loadImage = function(lazyImage) {
    if (lazyImage.dataset.src) { lazyImage.src = lazyImage.dataset.src; }
    if (lazyImage.dataset.srcset) { lazyImage.srcset = lazyImage.dataset.srcset; }
  };

  if ("IntersectionObserver" in window) {
    let lazyImageObserver = new IntersectionObserver(function(entries) {
      entries.forEach(function(entry) {
        if (entry.isIntersecting) {
          let lazyImage = entry.target;
          loadImage(lazyImage);
          lazyImageObserver.unobserve(lazyImage);
        }
      });
    }, {
      rootMargin: "50%"
    });

    lazyImages.forEach(function(lazyImage) {
      lazyImageObserver.observe(lazyImage);
    });
  } else {
    // Possibly fall back to a more compatible method here
    let active = false;

    let isImgVisible = function (lazyImage) {
      return (lazyImage.getBoundingClientRect().top <= window.innerHeight) &&
             (lazyImage.getBoundingClientRect().bottom >= 0) &&
             getComputedStyle(lazyImage).display !== "none";
    };

    let lazyLoad = function() {
      if (!active) {
        active = true;

        setTimeout(function() {
          lazyImages.forEach(function(lazyImage) {
            if (isImgVisible(lazyImage)) {
              loadImage(lazyImage);

              lazyImages = lazyImages.filter(function(image) {
                return image !== lazyImage;
              });

              if (lazyImages.length === 0) {
                window.removeEventListener("scroll", lazyLoad);
                window.removeEventListener("resize", lazyLoad);
                window.removeEventListener("orientationchange", lazyLoad);
              }
            }
          });

          active = false;
        }, 200);
      }
    };

    window.addEventListener("scroll", lazyLoad);
    window.addEventListener("resize", lazyLoad);
    window.addEventListener("orientationchange", lazyLoad);
  }
});
