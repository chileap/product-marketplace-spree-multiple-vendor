Spree.apiV2Authentication = function() {
  if (typeof(OAUTH_TOKEN) !== 'undefined') {
    return {
      'Authorization': 'Bearer ' + OAUTH_TOKEN
    }
  }
}


Spree.ready(function() {
  var productTaxonSelector = document.getElementById('product_taxon_ids')
  if (productTaxonSelector == null) return
  // $('#product_taxon_ids').select2()
})
