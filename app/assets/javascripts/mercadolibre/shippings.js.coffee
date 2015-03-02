AIRCRM.mercadolibre_shippings = ((document, window, $) ->
  #########################
  ###   Controllers     ###
  #########################

  index = ->
    console.debug "shipping#index"

  show = ->
    console.debug "shipping#show"

    # Close sidebar
    $(".fa-bars"         ).trigger("click")

  form = (id) ->
    console.debug "shipping#form"
    unless id
      id = $("[data-shiping-id]").data("shiping-id")

    console.debug "id", id


    $shipping = $("#shipping-#{id}")
    $resulted = $shipping.find(".shipping_resulted" ).hide()
    $form     = $shipping.find(".shipping_form"     ).show()

    $form.find("#cancel").on "click", (event) ->
      event.preventDefault()
      $resulted.show()
      $form.hide()

    bind_edit_link $resulted.find("#edit")

  update = (id, params, html_or_errors) ->
    console.debug "shipping#update", id, params, html_or_errors

    $("#shipping-#{id} .shipping_resulted").html(view);

    eval("update_#{params.action}")(id, params, html_or_errors)


  update_show = (id, params, html) ->
    console.debug "shipping#update from show:", id, params
    console.debug "html:", html

    $("#shipping-#{id} .shipping_resulted").html(html);

    bind_edit_link $("#shipping-#{id} #edit")

    $("#shipping-#{id} #cancel").click()


  update_status = (id, params, errors) ->
    console.debug "shipping#update from status:", id, params
    console.debug "errors:", errors

    unless errors.length
      $shipping_modal = $("#shipping-modal.modal")
      $shipping_modal.data("no-reset-after", true)
      $shipping_modal.modal('hide')




  #########################
  ###     Methods       ###
  #########################
  bind_edit_link = ($btn) ->
    $btn.on("click", (event) ->
      event.preventDefault()
      $(".shipping_resulted" ).hide()
      $(".shipping_form"     ).show().find("[autofocus]").focus()
    ).removeAttr("data-remote")

  # return
  {
    # Methods
    index:    index
    show:     show
    edit:     form
    new:      form
    receiver: form
    update:   update
  }
) document, window, jQuery
AIRCRM.mercadolibre_shippings = AIRCRM.mercadolibre_shippings
