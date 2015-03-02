class Aircrm.Views.CategoriesIndex extends Backbone.View

  @options: {}

  template: JST['categories/index']

  el: '<div class="category_index" />'

  initialize: (args) ->
    @collection = new Aircrm.Collections.Categories() unless @collection

  render: ->
    @$el.html(@template(categories: @collection))
    this
