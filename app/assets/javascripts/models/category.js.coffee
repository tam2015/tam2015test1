class Aircrm.Models.Category extends Backbone.RelationalModel

  initialize: () ->
    @dashboard_id = Aircrm.dashboard && Aircrm.dashboard.id

  url: (models) ->
    "/d/#{@dashboard_id}/categories/#{@id}"
