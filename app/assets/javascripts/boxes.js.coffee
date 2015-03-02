AIRCRM.boxes = ((document, window, $) ->

  # errors = {}
  reset_after_modal = true

  #########################
  ###   Controllers     ###
  #########################

  index = ->
    console.debug "box#index"

  show = ->
    console.debug "box#show"

  form = (id) ->
    console.debug "box#form"

    $box = $("#box-#{id}")
    $resulted = $box.find(".box_resulted" ).hide()
    $form     = $box.find(".box_form"     ).show()

    $form.find("#cancel").on "click", (event) ->
      event.preventDefault()
      $resulted.show()
      $form.hide()

    bind_edit_link $resulted.find("#edit")

  update = (id, params, html_or_errors) ->
    console.debug "box#update", "params:", params

    eval("update_#{params.action}")(id, params, html_or_errors)

  update_show = (id, params, html) ->
    console.debug "box#update from show:", id, params
    console.debug "html:", html
    $("#box-#{id} .box_resulted").html(html);

    bind_edit_link $("#box-#{id} #edit")

    $("#box-#{id} #cancel").click()

  update_status = (id, params, errors) ->
    console.debug "box#update from status:", id, params
    console.debug "errors:", errors

    box = $("##{id}.step-box")

    unless errors.length
      $box_modal = $("#box-modal.modal")
      $box_modal.data("no-reset-after", true)
      $box_modal.modal('hide')


  #########################
  ###     Methods       ###
  #########################
  bind_edit_link = ($btn) ->
    $btn.on("click", (event) ->
      event.preventDefault()
      $(".box_resulted" ).hide()
      $(".box_form"     ).show().find("[autofocus]").focus()
    ).removeAttr("data-remote")

  # return
  {
    # Methods
    index:  index
    show:   show
    edit:   form
    new:    form
    update: update
    # errors: errors
    reset_after_modal: reset_after_modal
  }
) document, window, jQuery
