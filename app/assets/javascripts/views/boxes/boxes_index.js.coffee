class Aircrm.Views.BoxesIndex extends Backbone.View

  # model: new Aircrm.Models.Box()
  # collection: Aircrm.Models.Box

  @options: {}

  template: JST['boxes/index']
  templateForStep: JST['steps/boxes']
  used_template: null

  isLoading: false


  selectTemplate: ->
    @used_template = switch @bodyData.route
      when "dashboards#show"
        @templateForStep
      else
        @template

  body_data: (attr) ->
    @bodyData = $("body").data(attr)






  initialize: (args) ->
    console.debug("on model ----", args)

    @model      = if args["model"     ] then args["model"     ] else new Aircrm.Models.Box()
    @collection = if args["collection"] then args["collection"] else new Aircrm.Collections.Boxes()
    @options    = _(args["options"] || {}).extend @options

    @step = @collection.step
    @el   = ".steps-canvas .step##{@step.id} .step-boxes"
    @$el  = $(@el)
    @bodyData  = $("body").data()

    @listenTo(
      @collection
      'sync'
      # 'reset change read'
      # (collection, resp, options) =>
      #   console.debug('sync');
      #   console.debug("bodyData", @bodyData)
      #   @render()
      @render
      this
    )

    @collection.fetch(@options) if @collection.length == 0

  render: ->
    console.debug("@bodyData", @bodyData)
    console.debug("@collection", @collection.fullCollection.length, @collection.fullCollection)
    console.debug("@$el", @$el)

    @selectTemplate()
    @$el
      .html(@used_template(boxes: @collection.fullCollection))
      .jscroll(
        load: ()=>
          @collection.getNextPage()
      )
    this
