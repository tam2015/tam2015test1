// 3 entities needed
//  - Box
//  - Label

AIRCRM.label = (function(document, window, $) {

  var currentLabel,
      printableItems = [];

  /**
   * Labels initializer
   * Fired by Dispatcher
   * @param {null}
   * @return {null}
   */
  function index(toggle_sidebar) {
    console.log("Here we are!");
    // toogle sidebar (hide)
    // TODO: place inside a 'common.js'
    toggle_sidebar = toggle_sidebar || true;
    // if (toggle_sidebar == null) toggle_sidebar = true;

    // attach resize event to fix column sizes
    // TODO: place inside a 'common.js'
    window.onresize = AIRCRM.dashboards.layoutSizes;

    // From 'dashboards.js.coffee'
    AIRCRM.dashboards.layoutSizes();

    // ??
    if (toggle_sidebar) $(".fa-bars").trigger("click");
  }

  return {
    index: index
  }

})(document, window, jQuery);
// pid: ,
// payment_status: ,
// customer: ,
// price: ,
// status: ,
// status: ,
// pid(box_id), customer (customer.ml_id), payment_status, price, status (box_status), extras (shipping[receiver_address,shipment_type,shipping_mode] / payments)
