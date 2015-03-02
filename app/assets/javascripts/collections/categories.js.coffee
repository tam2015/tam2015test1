class Aircrm.Collections.Categories extends Backbone.Collection

  model: Aircrm.Models.Category

  initialize: () ->
    @dashboard_id = Aircrm.dashboard && Aircrm.dashboard.id
    @selected_id = null

  url: (models) ->
    # Logic to create a url for the whole collection, or a set of models.
    # See the tests, or Backbone-tastypie, for an example.
    category_url = if models then "/#{_.pluck(models, "id")}/" else ""
    "/d/#{@dashboard_id}/categories#{category_url}"
