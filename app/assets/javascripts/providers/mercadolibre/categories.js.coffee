AIRCRM.mercadolibre_categories = ((document, window, $) ->
  window.CATEGORIES = {}

  #########################
  ###   Controllers     ###
  #########################

  index = ->
    console.debug "category#index"

  show = ->
    console.debug "category#show"

    # Close sidebar
    $(".fa-bars"         ).trigger("click")

  suggest = ->
    console.debug "category#suggest"

    $parent     = $(".category_list")
    $input      = $("[data-model=category_id]")
    category    = $input.data("category");
    parent_url  = $parent.data("url")

    console.debug "category#suggest parent_url", parent_url
    console.debug "category#suggest category", category

    unless category
      category_form_toggle()

    $(document).on "click", ".category_list #category_form_toggle", (event) ->
      event.preventDefault()
      category_form_toggle()

    $(document).on("click", ".dd-item [data-action=select]", (event) ->
      event.preventDefault()
      $btn    = $(event.target).closest("a").addClass("btn-success disabled").removeClass("btn-info")
      $item   = $btn.closest(".dd-item")
      $input.val($item.data("id"))
    )

    $(document).on("click", ".dd-item[data-children=null] [data-action=load]", (event) ->
      event.preventDefault()

      $item   = $(event.target).closest(".dd-item").addClass("loading")
      url     = "#{parent_url}/#{$item.data("id")}"

      $.get("#{url}", (data) ->
        $item.replaceWith(data)
        $new_item = $(".dd-item##{$item.data("id")}:last")
        $new_item.parent().nestable()
      )
    )


  form = ->
    console.debug "category#form"

    category_suggest()


  category_form_toggle = (event) ->
    $divs = $("#category_selected_container, #categories_suggest_container")
    $form = $divs.filter("#categories_suggest_container")

    console.debug("category_form_toggle $divs", $divs)
    console.debug("category_form_toggle $form", $form)

    toggle = =>
      $divs.toggle ->
        $("input[autofocus]", this).focus()

    console.debug("category_form_toggle loaded?", $form.hasClass("loaded"))

    unless $form.hasClass("loaded")
      href = $form.data("url")
      console.debug("category_form_toggle href", href)

      $.get("#{href}", (data) ->
        $form.addClass("loaded").html data
        AIRCRM.mercadolibre_categories.form()
        toggle()
        )
    else
      toggle()






  #########################
  ###     Methods       ###
  #########################

  ### Category Suggest  ###
  category_suggest = ->
    $input  = $("input#category_suggest")
    $submit = $("#category_suggest_submit")
    $result = $(".categories_suggest_result")

    return unless $input.length and $submit.length and $result.length

    url = $input.data("url")
    return unless url


    category_paths_to_breadcrumb = (paths) ->
      paths.map( (path) -> path.name )

    # Load suggests
    suggest_callback = (data) ->
      $result.html data
      $("#categories_selector").nestable().nestable("collapseAll")

    $submit.on "click", (event) =>
      value = $input.val()
      query =
        q: value

      $.get(url, query, suggest_callback)


    # get suggest instande of send for id key press ennter
    $input.on "keypress", (event) ->
      if event.keyCode == 13 # ENTER
        event.preventDefault()
        $submit.click()


  # return
  {
    # Methods
    index:  index
    show:   show
    form:   form
    suggest: suggest
  }
) document, window, jQuery
