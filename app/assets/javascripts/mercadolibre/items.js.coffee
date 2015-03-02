AIRCRM.mercadolibre_items = ((document, window, $) ->
  window.CATEGORIES = {}

  #########################
  ###   Controllers     ###
  #########################

  index = ->
    console.debug "item#index"

  show = ->
    console.debug "item#show"

  form = ->
    console.debug "item#form"
    # Close sidebar
    $(".fa-bars"         ).trigger("click")

    window.item     = @model = new Aircrm.Models.Item(window.ITEM)
    console.debug("item", item)
    window.itemForm = @view = new Aircrm.Views.ItemsForm
      model: @model


    # Category
    window.categoryForm = new Aircrm.Views.CategoriesForm({ model: @model.category })
    $(".item_category_id").append(categoryForm.el)



  #########################
  ###     Methods       ###
  #########################

  # return
  {
    # Methods
    index:  index
    show:   show
    edit:   form
    new:    form
  }
) document, window, jQuery
