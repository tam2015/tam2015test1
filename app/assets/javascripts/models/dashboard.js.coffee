class Aircrm.Models.Dashboard extends Backbone.RelationalModel
  urlRoot: "/d"
  relations: [
    {
      type: Backbone.HasMany
      key: "steps"

      relatedModel: "Aircrm.Models.Step"
      collectionType: "Aircrm.Collections.Steps"

      reverseRelation:
        key: 'dashboard'
        includeInJSON: '_id'
    }
  ]
  initialize: () ->

