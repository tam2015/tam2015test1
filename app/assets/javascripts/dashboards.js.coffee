AIRCRM.dashboards = ((document, window, $) ->

  #########################
  ###   Controllers     ###
  #########################

  index = ->
    console.debug "dashboard#index"
    tour()

  show = (toggle_sidebar = true) ->
    console.debug "dashboard#show"


  ### Methods ###

  # Sortable steps
  sortableSteps =  ->
    sortable = $(".steps-canvas.ui-sortable")
      .sortable
        appendTo: document.body
        # connectWith: ".step-boxes.ui-sortable"
        items: ".step.ui-droppable"
        placeholder: "step ui-droppable active-step ui-sortable-helper"
        handle: ".step-header"
        forcePlaceholderSize: true
        forcePlaceholderSizeType: true

        ### Events ###
        stop: (event, ui) ->
          $record = $(event.toElement)
          $canvas = $record.closest(".steps-canvas")

          $.ajax
            url: $canvas.data "update_url"
            type: 'post'
            data:
              sort: $canvas.sortable "toArray"
            complete: (request) =>
              console.debug "request sort step", request

      .disableSelection()

  # Sortable boxes
  sortableBoxes =  ->
    sortable = $(".step-boxes.ui-sortable")
      .sortable
        appendTo: document.body
        connectWith: ".step-boxes.ui-sortable"
        items: ".step-box.ui-droppable"
        placeholder: "step-box ui-droppable active-box ui-sortable-helper step-box-details"
        forcePlaceholderSize: true
        forcePlaceholderSizeType: true

        ### Events ###
        start: (event, ui) ->
          $box = ui.item
          $step = $box.closest(".step-boxes")
          orders = $step.sortable("toArray")

          # save original sender and position in sender
          $box.data("sender", $step)
          $box.data("positionInSender", orders.indexOf($box.attr("id")))

          # console.debug "start: ui.sender", orders.indexOf($box.attr("id")), orders, $(ui.sender)

        stop: (event, ui) ->
          $box = ui.item

          $receiver = $box.closest(".step-boxes")
          $sender   = $box.data("sender")

          # no call updateStatus if no changed status (step)
          updateStatus ui unless $sender.data("status") == $receiver.data("status")

          # $.ajax
          #   url: $step.data "update_url"
          #   type: 'post'
          #   data:
          #     sort: $step.sortable "toArray"
          #   complete: (request) =>
          #     console.debug "request sort box", request


      .disableSelection()

  updateStatus = (ui) ->
    $box = ui.item
    # console.debug "updateStatus box", $box, $box.data()

    $step = $box.closest(".step-boxes")
    # console.debug "updateStatus step", $step, $step.data()

    $.ajax
      url: "#{$box.data("update_url")}/status",
      type: "post"
      data:
        box:
          status: $step.data("status")
          old_position: $box.data("positionInSender")
      complete: (request) =>
        console.debug "request update box status COMPLETE", request

      success: (data, textStatus, xhr) =>
        $box_modal = $("body")
          .find("#box-modal.modal")
            .remove()
          .end()
          .append(data)
          .find("#box-modal.modal")
            .modal()

        $box_modal.on("hide.bs.modal", (event) ->
          console.debug "hide modal", $box
          console.debug "hide modal", this

          unless $box_modal.data("no-reset-after")
            resetPosition $box
        )
      error: (xhr, textStatus, errorThrown) =>
        resetPosition $box

    # Sort boxes
    # $.ajax
    #   url: "#{$box.data("update_url")}/status",
    #   type: "post"
    #   data:
    #     box: $step.data("status")
    #     old_position: $box.data("positionInSender")
    #   complete: (request) =>
    #     console.debug "request update box status", request

    #     $("body")
    #       .find("#box-modal.modal")
    #         .remove()
    #       .end()
    #       .append(request)
    #       .find("#box-modal.modal")
    #         .modal();

    console.debug "updateStatus", $box
    true

  resetPosition = ($box) ->
    $box = $($box)
    data = $box.data()
    $box.insertAt(data.positionInSender, data.sender)

  layoutSizes   = ->
    # DOM
    $dashboard              = $("#main-content .dashboard:first")

    $steps_canvas_wrapper   = $(".steps-canvas-wrapper", $dashboard)
    $steps_canvas           = $(".steps-canvas", $dashboard)
    $steps                  = $(".step", $steps_canvas)


    # Sizes
    dashboard_sizes   = getSizes($dashboard)


    # Set steps_canvas_wrapper sizes
    $steps_canvas_wrapper.height  dashboard_sizes.innerHeight

    # Set canvas sizes
    $steps_canvas.height(dashboard_sizes.innerHeight)

    # cache step margin, padding and step-header size
    $first_step  = $steps.first()
    # step_width  = $first_step.outerWidth()
    step_margin = parseFloat($first_step.css("margin"))

    # Step Header
    $step_header = $first_step.find(".step-header")
    step_header_height = $step_header.outerHeight()
    step_header_padding = parseFloat($step_header.css("margin-bottom"))

    # Cache step box height
    step_box_height = dashboard_sizes.innerHeight - (step_header_height + (step_margin + step_header_padding) *2 )


    # Start Steps width
    # last_steps_width = 0

    # Set steps height
    # $steps.each ->
    #   # update last_steps_width
    #   last_steps_width += step_width + step_margin

    # Set step_boxes height
    $steps.find(".step-boxes").height(step_box_height)

    # $steps_canvas.width last_steps_width + step_margin

  tour = ->
    # Instance the tour
    new_tour = new Tour(
      name: "dashboard"
      steps: [
        {
          element: "#dashboard_synced"
          title: "Conheça seu Painel"
          content: "Sua conta já foi sincronizada, porém que tal conhecer seu Painel antes de começar a gerenciar suas vendas?"
          backdrop: true
        }, {
          element: "#dashboard_not_synced"
          title: "Conheça seu Painel"
          content: "Enquanto sua conta é sincronizada que tal conhecer seu Painel?"
          backdrop: true
        }, {
          element: ".state-overview"
          title: "Resumo"
          content: "Aqui você tem o número de contas, clientes, vendas, e valor total de todas suas vendas."
          placement: "bottom"
        }, {
          element: "#header_tools"
          title: "Usuário"
          content: "Acessar as informações de sua conta são fáceis de acessar."
          placement: "bottom"
        }, {
          element: ".sidebar"
          title: "Ferramentas para sua conta"
          content: "Você pode ter acesso as principais funcionalidades de sua conta clicando nos atalhos disponíveis."
        }, {
          element: ".dashboard_to_boxes"
          title: "Gerenciador de vendas"
          content: "Visualizar e gerenciar suas vendas nunca foi tão simples, basta clicar e você já será redirecionado."
        }
      ]
    )

    # Initialize the tour
    new_tour.init()

    # Start the tour
    new_tour.start()

  # private methods
  getSizes = (el) ->
    $el = $(el)
    sizes = {}

    if $el.length
      $.each ["width", "innerWidth", "outerWidth", "height", "innerHeight", "outerHeight"], (ix, fn) ->
        sizes[fn] = $el[fn]()

    sizes

  # return
  {
    # Methods
    index: index
    show:   show
    layoutSizes: layoutSizes
    layoutSizes: layoutSizes
    tour: tour
  }
) document, window, jQuery
