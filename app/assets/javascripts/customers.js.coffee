AIRCRM.customers = ((document, window, $) ->
  #########################
  ###   Controllers     ###
  #########################

  index = ->
    console.debug "customer#index"

  show = ->
    console.debug "customer#show"

  form = (id) ->
    console.debug "customer#form"

    $customer = $("#customer-#{id}")
    $resulted = $customer.find(".customer_resulted" ).hide()
    $form     = $customer.find(".customer_form"     ).show()

    $form.find("#cancel").on "click", (event) ->
      event.preventDefault()
      $resulted.show()
      $form.hide()

    bind_edit_link $resulted.find("#edit")

  update = (id) ->
    console.debug "customer#update"

    bind_edit_link $("#customer-#{id} #edit")

    $("#customer-#{id} #cancel").click()


  #########################
  ###     Methods       ###
  #########################
  bind_edit_link = ($btn) ->
    $btn.on("click", (event) ->
      event.preventDefault()
      $(".customer_resulted" ).hide()
      $(".customer_form"     ).show().find("[autofocus]").focus()
    ).removeAttr("data-remote")

  # return
  {
    # Methods
    index:  index
    show:   show
    edit:   form
    new:    form
    update: update
  }
) document, window, jQuery
