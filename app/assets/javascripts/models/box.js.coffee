class Aircrm.Models.Box extends Backbone.RelationalModel

  url: (models) ->
    # Logic to create a url for the whole collection, or a set of models.
    # See the tests, or Backbone-tastypie, for an example.
    box_url = if models then "/#{_.pluck(models, "id")}/" else ""
    "/d/#{@dashboard_id}/b#{box_url}"
