window.Aircrm =
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}
  init: ->
    # alert 'Hello from Backbone!'
    console.debug "before load dashboard"
    new Aircrm.Routers.Dashboards
    Backbone.history.start pushState: true
    console.debug "before backbone"

$(document).ready ->
  console.debug "backbone page:read"
  Aircrm.init()

$(document).on 'page:load', ->
  console.debug "backbone page:load"
  Backbone.history.stop()
  Aircrm.init()
