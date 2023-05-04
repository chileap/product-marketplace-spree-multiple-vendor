import "./viewport";

Spree.fetchProductCarousel = function (taxonId, htmlContainer) {
  return $.ajax({
    url: Spree.routes.product_carousel(taxonId)
  }).done(function (data) {
    htmlContainer.html(data);
    new bootstrap.Carousel(htmlContainer.find('.carousel')[0], {
      interval: false
    });
  })
}

Spree.loadCarousel = function (element, div) {
  var container = $(element)
  var productCarousel = $(div)
  var carouselLoaded = productCarousel.attr('data-product-carousel-loaded')

  if (container.length && !carouselLoaded && container.isInViewport()) {
    var taxonId = productCarousel.attr('data-product-carousel-taxon-id')
    productCarousel.attr('data-product-carousel-loaded', 'true')

    Spree.fetchProductCarousel(taxonId, container)
  }
}

Spree.loadsCarouselElements = function () {
  $('div[data-product-carousel-taxon-id]').each(function (_index, element) { Spree.loadCarousel(element, this) })
}

document.addEventListener('turbo:load', function () {
  var carouselPresent = $('div[data-product-carousel-taxon-id]')

  if (carouselPresent.length) {
    // load Carousels straight away if they are in the viewport
    Spree.loadsCarouselElements()

    // load additional Carousels when scrolling down
    $(window).on('resize scroll', function () {
      Spree.loadsCarouselElements()
    })
  }
})
