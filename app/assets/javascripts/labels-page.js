// Plugins
//= require plugins/jsbarcode/CODE128
//= require plugins/jsbarcode/CODE39
//= require plugins/jsbarcode/EAN_UPC
//= require plugins/jsbarcode/ITF
//= require plugins/jsbarcode/ITF14
//= require plugins/jsbarcode/JsBarcode
// Backbone
//= require label

console.log('labels-page.js');

var Aircrm          = Aircrm || {};

Aircrm.Model        = Aircrm.Model || {},
Aircrm.View         = Aircrm.View || {},
Aircrm.Collection   = Aircrm.Collection || {};

var Application = {
  Collection: {},
  View: {},
  Model: {}
};


/**
 *
 * Boxes Backbone Classes
 *
 */

Application.Model.Box = Backbone.Model.extend();

Application.Collection.Boxes = Backbone.Collection.extend({
  model: Application.Model.Box,
  comparator: function(model) {
    return model.get('ordinal');
  },
});

// Appended through Application.View.Boxes
Application.View.Box = Backbone.View.extend({
  template: _.template( $('#box-item-template').html() ),
  events: {
    'drop' : 'drop'
  },
  drop: function(event, index) {
    this.$el.trigger('update-sort', [this.model, index]);
  },
  render: function() {
    // console.log(this.model.toJSON());
    this.$el.append( this.template(this.model.toJSON()) );
    // this.$el.html(this.model.get('name') + ' (' + this.model.get('id') + ')');
    return this;
  }
});

Application.View.Boxes = Backbone.View.extend({
  events: {
      'update-sort': 'updateSort'
  },
  render: function() {
    this.$el.children().remove();
    this.collection.each(this.appendModelView, this);
    return this;
  },
  appendModelView: function(model) {
    var el = new Application.View.Box({model: model}).render().el;
    this.$el.append(el);
  },
  updateSort: function(event, model, position) {
    this.collection.remove(model);

    this.collection.each(function (model, index) {
      var ordinal = index;
      if (index >= position)
        ordinal += 1;
      model.set('ordinal', ordinal);
  });
    model.set('ordinal', position);
    this.collection.add(model, {at: position});
    this.render();
  }
});



/**
 *
 * Labels Backbone Classes
 *
 */

Application.Model.Label = Backbone.Model.extend();


Application.Collection.Labels = Backbone.Collection.extend({
  model: Application.Model.Label,
  comparator: function(model) {
    return model.get('ordinal');
  }
});

// Appended throught Application.View.Boxes
Application.View.Label = Backbone.View.extend({
  template: _.template( $('#label-item-template').html() ),
  render: function() {
    this.$el.append( this.template(this.model.toJSON()) );
    return this;
  }
});



Application.View.Labels = Backbone.View.extend({
  events: {
  },
  render: function() {
    this.$el.children().remove();
    this.collection.each(this.appendModelView, this);
    return this;
  },
  appendModelView: function(model) {
    var el = new Application.View.Label({model: model}).render().el;
    this.$el.append(el);
  }
});





/**
 * Filtering Boxes by shipping status
 * Status should be 'to_be_agreed' or 'peding'
 * @param  {array} statusFilters            Filters for box.extras.shipping.status
 * @param  {array} window.dashboard.boxes   List of Boxes with status_param: 'to_send'
 * @return {array} filteredBoxes            Boxes with shipping.status filtered
 */
var statusFilters = ['paid'],
    filteredBoxes = window.DASHBOARD.boxes;


/**
 * Labels page Object Initializer
 * @type {Object}
 */
var LabelsPage            = {};



/**
 * LabelsPage - Boxes init
 */

LabelsPage.Boxes          = new Application.Collection.Boxes( window.DASHBOARD.boxes );
LabelsPage.BoxesList      = new Application.View.Boxes({
  el: '#box-collection-view',
  collection: LabelsPage.Boxes
});

LabelsPage.BoxesList.render();


/**
 * LabelsPage - Labels init
 */


LabelsPage.Labels          = new Application.Collection.Labels();
LabelsPage.LabelsList      = new Application.View.Labels({
  el: '#labels-collection-view',
  collection: LabelsPage.Labels
});

// LabelsPage.LabelsList.render();


/**
 * jQuery UI Sortable Config.
 */

$(document).ready(function() {

  $('.collection-view').sortable({
    connectWith: '#label-container',
    items: '.step-box.ui-droppable',
    stop: function(event, ui) {
      $box = ui.item;
      $receiver = $box.closest(".step-boxes")

      // check if target container is .printable-labels
      // so we can fire drop event for item and add
      // box to labels collection
      if ($receiver.data("status") == "printable-labels") {
        ui.item.trigger('drop', ui.item.index());

        // rescue item to create Label model
        var selectedItemPid = ui.item.data('meli_order_id'),
            selectedItem    = _.find(filteredBoxes, function(item){
          return item.meli_order_id == selectedItemPid
        });

        // add to Labels collection and render
        LabelsPage.Labels.add(selectedItem);
        LabelsPage.LabelsList.render();

        // render Label Barcode
        $("img#barcode_" + selectedItemPid).JsBarcode(selectedItem.shipping_record.receiver_address.zip_code, {width: 1,height: 92,displayValue: true,fontSize:13});
      }
    }
  });

  // Reset Labels Btn
  // TODO: this should be moved to a PageView to handle these events
  $("#reset-labels").click(function(e) {
    LabelsPage.Labels.reset();
    LabelsPage.LabelsList.render();
    e.preventDefault();
  });

  var printContainer = _.template( $("#printer-container-template").html() ),
      $labelsClone;

  $("#print-labels").click(function(e) {
    $labelsClone = $("#labels-collection-view").clone();
    $('body').append( printContainer({}) );
    $('#printer-container #clone-area').append($labelsClone);
    // window.print();
    e.preventDefault();
  });

  $("body").on('click', '#close-print-container', function(e) {
    $("#printer-container").remove();
    e.preventDefault();
  });
});
