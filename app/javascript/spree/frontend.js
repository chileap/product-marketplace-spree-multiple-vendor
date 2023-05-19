import $ from 'jquery';
import select2 from 'select2';
window.$ = window.jQuery = $;

import * as bootstrap from "bootstrap"
window.bootstrap = bootstrap;

import "./vendors/cleave"
import "./frontend/main"
import "./vendors/polyfill.min"
import "./vendors/fetch.umd"
import "./frontend/api/main"
import "./lazysizes.config"
import "./vendors/lazysizes.min"
import "./vendors/accounting.min"
import "./frontend/api_tokens"
import "./frontend/cart"
import "./frontend/locale"
import "./frontend/currency"
import "./frontend/country"
import "./frontend/checkout"
import "./frontend/checkout/address"
import "./frontend/checkout/address_book"
import "./frontend/checkout/payment"
import "./frontend/checkout/shipment"
import "./frontend/views/spree/layouts/spree_application"
import "./frontend/views/spree/product/related"
import "./frontend/views/spree/products/cart_form"
import "./frontend/views/spree/products/description"
import "./frontend/views/spree/products/index"
import "./frontend/views/spree/products/price_filters"
import "./frontend/views/spree/products/product_form"
import "./frontend/views/spree/users/show"
import "./frontend/views/spree/shared/carousel"
import "./frontend/views/spree/shared/carousel/single"
import "./frontend/views/spree/shared/carousel/swipes"
import "./frontend/views/spree/shared/carousel/thumbnails"
import "./frontend/views/spree/shared/delete_address_popup"
import "./frontend/views/spree/shared/mobile_navigation"
import "./frontend/views/spree/shared/nav_bar"
import "./frontend/views/spree/shared/product_added_modal"
import "./frontend/views/spree/shared/quantity_select"
import "./frontend/turbo_scroll_fix"
import "./frontend/main_nav_bar"
import "./frontend/login"

Spree.routes.api_tokens = Spree.localizedPathFor('api_tokens')
Spree.routes.ensure_cart = Spree.localizedPathFor('ensure_cart')
Spree.routes.api_v2_storefront_cart_apply_coupon_code = Spree.localizedPathFor('api/v2/storefront/cart/apply_coupon_code')
Spree.routes.api_v2_storefront_cart_remove_coupon_code = function(couponCode) { return Spree.localizedPathFor('api/v2/storefront/cart/remove_coupon_code/' + couponCode) }
Spree.routes.api_v2_storefront_destroy_credit_card = function(id) { return Spree.localizedPathFor('api/v2/storefront/account/credit_cards/' + id) }
Spree.routes.product = function(id) { return Spree.localizedPathFor('products/' + id) }
Spree.routes.product_related = function(id) { return Spree.localizedPathFor('products/' + id + '/related') }
Spree.routes.product_carousel = function (taxonId) { return Spree.localizedPathFor('product_carousel/' + taxonId) }
Spree.routes.set_locale = function(locale) { return Spree.localizedPathFor('locale/set?switch_to_locale=' + locale) }
Spree.routes.set_currency = function(currency) { return Spree.localizedPathFor('currency/set?switch_to_currency=' + currency) }
Spree.routes.set_country = function(countryId) { return Spree.localizedPathFor('country/set?switch_to_country_id=' + countryId) }

Spree.clearCache = function () {
  if (!window.Turbo) { return }

  Turbo.clearCache()
}

Spree.setCurrency = function (currency) {
  Spree.clearCache()

  var params = (new URL(window.location)).searchParams
  if (currency === SPREE_DEFAULT_CURRENCY) {
    params.delete('currency')
  } else {
    params.set('currency', currency)
  }
  var queryString = params.toString()
  if (queryString !== '') { queryString = '?' + queryString }

  SPREE_CURRENCY = currency

  Turbo.visit(window.location.pathname + queryString, { action: 'replace' })
}

Spree.setCountry = function (country) {
  Spree.clearCache()

  var params = (new URL(window.location)).searchParams
  if (country === SPREE_DEFAULT_COUNTRY) {
    params.delete('country')
  } else {
    params.set('country', country)
  }
  var queryString = params.toString()
  if (queryString !== '') { queryString = '?' + queryString }

  SPREE_COUNTRY = country

  Turbo.visit(window.location.pathname + queryString, { action: 'replace' })
}

select2($);

Spree.ready(function() {
  $('.select2').select2();
});

