class Aircrm.Collections.Items extends Backbone.Collection

  model: Aircrm.Models.Item

  initialize: () ->
    @dashboard_id = Aircrm.dashboard && Aircrm.dashboard.id

  url: (models) ->
    # Logic to create a url for the whole collection, or a set of models.
    # See the tests, or Backbone-tastypie, for an example.
    item_url = if models then "/#{_.pluck(models, "id")}/" else ""
    "/d/#{@dashboard_id}/items#{category_url}"
