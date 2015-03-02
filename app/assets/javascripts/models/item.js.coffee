class Aircrm.Models.Item extends Backbone.DeepRelationalModel

  non_mercado_pago_payment_methods: [
    { "id": "MLBCC", "description": "Cartão de Crédito", "type": "N" }
    { "id": "MLBMO", "description": "Dinheiro", "type": "G" }
    { "id": "MLBDE", "description": "Depósito Bancário", "type": "D" }
  ]

  defaults: {
    "shipping": {
      "mode"          : "not_specified",
      "local_pick_up" : false,
      "free_shipping" : false,
      "methods"       : [],
      "dimensions"    : null,
    }
  }

  initialize: () ->
    @id = @get("_id.$oid")
    @dashboard_id = Aircrm.dashboard && Aircrm.dashboard.id

    # set category
    @changeCategoryId()

    this

  url: (models) ->
    "/d/#{@dashboard_id}/items/#{@id}"


  # ClassMethods
  changeCategoryId: (model) ->
    category_id    = @get("category_id")
    built_category = @get("category")
    console.debug("changeCategoryId", category_id, built_category)

    if built_category
      @unset("category", { silent: true })

    if category_id and built_category and category_id == built_category.id
      category = Aircrm.Models.Category.findOrCreate(built_category)
    else if category_id
      category = Aircrm.Models.Category.findOrCreate(category_id)

    @category = category || new Aircrm.Models.Category

    this

