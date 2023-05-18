Spree.ready(function () {
  var countrySelect = document.querySelectorAll('select[name=switch_to_country]')

  if (countrySelect.length) {
    countrySelect.forEach(function (element) {
      element.addEventListener('change', function () {
        var newCountry = this.value
        console.log(newCountry)

        // we need to make AJAX call here to the backend to set country in session
        fetch(Spree.routes.set_country(newCountry), {
          method: 'GET'
        }).then(function (response) {
          switch (response.status) {
            case 200:
              Spree.setCountry(newCountry)

              const modalEl = document.getElementById('internationalization-options-desktop');
              const modal = bootstrap.Modal.getInstance(modalEl);
              console.log(modal)
              if (modal) modal.hide()
              break
          }
        })
      })
    })
  }
})

// fix back button issue with different country set
// invalidate page if cached page has different country then the current one
document.addEventListener('turbo:load', function(event) {
  if (typeof (SPREE_DEFAULT_COUNTRY) !== 'undefined' && typeof (SPREE_COUNTRY) !== 'undefined') {
    if (SPREE_COUNTRY === SPREE_DEFAULT_COUNTRY) {
      var regexAnyCountry = new RegExp('country=')
      if (event.detail.url.match(regexAnyCountry) && !event.detail.url.match(SPREE_COUNTRY)) {
        Spree.setCountry(SPREE_COUNTRY)
      }
    } else {
      var regex = new RegExp('country=' + SPREE_COUNTRY)
      if (!event.detail.url.match(regex)) {
        Spree.setCountry(SPREE_COUNTRY)
      }
    }
  }
})
