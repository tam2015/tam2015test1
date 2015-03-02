class Aircrm.Views.DashboardsBoxesIndex extends Backbone.View

  template: JST['dashboards/boxes_index']

  render: ->
    $(@el).html(@template())
    this
