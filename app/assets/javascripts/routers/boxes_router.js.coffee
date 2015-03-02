class Aircrm.Routers.Boxes extends Backbone.Router
  routes:
    'd/:dashboard_id/b': 'index'
    'd/:dashboard_id/b/:id': 'show'

  initialize: ->
    @collection = new Aircrm.Collections.Boxes()
    # @collection.fetch()

  index: (dashboard_id, options) ->
    console.debug "Dashboard #{dashboard_id} with boxes"

  show: (dashboard_id, id, options) ->
    console.debug "Box #{id}"
    # console.debug "boxes_urls"
