Spree.ready(function () {
  var currencySelect = document.querySelectorAll('select[name=switch_to_currency]')

  if (currencySelect.length) {
    currencySelect.forEach(function (element) {
      element.addEventListener('change', function () {
        var newCurrency = this.value
        console.log(newCurrency)

        // we need to make AJAX call here to the backend to set currency in session
        fetch(Spree.routes.set_currency(newCurrency), {
          method: 'GET'
        }).then(function (response) {
          switch (response.status) {
            case 200:
              Spree.setCurrency(newCurrency)

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

// fix back button issue with different currency set
// invalidate page if cached page has different currency then the current one
document.addEventListener('turbo:load', function(event) {
  if (typeof (SPREE_DEFAULT_CURRENCY) !== 'undefined' && typeof (SPREE_CURRENCY) !== 'undefined') {
    if (SPREE_CURRENCY === SPREE_DEFAULT_CURRENCY) {
      var regexAnyCurrency = new RegExp('currency=')
      if (event.detail.url.match(regexAnyCurrency) && !event.detail.url.match(SPREE_CURRENCY)) {
        Spree.setCurrency(SPREE_CURRENCY)
      }
    } else {
      var regex = new RegExp('currency=' + SPREE_CURRENCY)
      if (!event.detail.url.match(regex)) {
        Spree.setCurrency(SPREE_CURRENCY)
      }
    }
  }
})
