class Aircrm.Views.DashboardsIndex extends Backbone.View

  template: JST['dashboards/index']

  render: ->
    $(@el).html(@template())
    this
