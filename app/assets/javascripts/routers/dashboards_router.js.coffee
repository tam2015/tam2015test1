class Aircrm.Routers.Dashboards extends Backbone.Router
  routes:
    'd': 'index'
    'd/:id': 'show'

  initialize: ->
    console.debug "Dashboard", window.DASHBOARD
    if window.DASHBOARD
      Aircrm.dashboard = Aircrm.Models.Dashboard.findOrCreate window.DASHBOARD
      console.debug "Dashboard #{Aircrm.dashboard.id}", Aircrm.dashboard

  index: ->
    console.debug "dashboards page"

  show: (id) ->
    Aircrm.steps     = Aircrm.dashboard.get("steps")

    if Aircrm.steps.length
      routeSteps = new Aircrm.Routers.Steps
      Aircrm.steps.each (step) ->
        routeSteps.show(id, step.id)
