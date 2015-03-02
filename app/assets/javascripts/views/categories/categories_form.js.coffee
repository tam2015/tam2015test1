class Aircrm.Views.CategoriesForm extends Backbone.View

  @options: {}

  template: JST['categories/form']

  tagName: 'li'
  show_form: true

  el: '<div class="category-container" />'
  input: '[data-model="category_id"]'

  suggest_input: "input#category_suggest"
  suggest_submit: "#category_suggest_submit"

  events:
    'click li': 'showCategory'
    'click .btn-category-edit': 'showForm'
    'click button#category_suggest_submit': 'getSuggests'

    'keypress input#category_suggest': (event) ->
      # pressed ENTER
      if event.keyCode == 13
        event.preventDefault()
        @getSuggests()




  initialize: (args) ->
    args || (args = {});
    _.extend(this, _.pick(args, []));

    @collection = new Aircrm.Collections.Categories() unless @collection

    @attachModelEvents()
    @attachCollectionEvents()

    @initialized = true
    @afterInitialize()
    this

  afterInitialize: (args) ->
    childrens = @model.get("children_categories")

    if _.isArray(childrens) and childrens.length == 0
      # hidden form
      @show_form = false
      @updateSelected(@model.id) unless @collection.selected_id == @model.id
    else
      @updateSelected() unless @collection.selected_id == null


    @render()

    # render categories list
    if @model.id
      @collection.reset(childrens)
    else
      @collection.fetch({ reset: true })

    this

  updateSelected: (selected_id = null) ->
    @collection.selected_id = selected_id

    $(@input).val(selected_id).trigger("change") if @input

  attachModelEvents: () ->
    @listenTo(@model, 'sync', @afterInitialize)

    this

  attachCollectionEvents: () ->
    unless @initialized
      @listenTo(@collection, 'reset', @renderIndex)

  # Events
  showCategory: (ev) ->
    ev.preventDefault()
    $li   = $(ev.currentTarget)
    data  = $li.data("category")

    unless @collection.selected_id == data.id
      @model = Aircrm.Models.Category.findOrCreate({ id: data.id })
      @attachModelEvents()
      @model.fetch()

  showForm: (event) ->
    event.preventDefault()
    $button = $(event.currentTarget)
    $form   = @$(".category_form")
    $input  = $form.find("input:text")

    $button.addClass("hidden")
    $form.removeClass("hidden")
    $input.focus()

  getSuggests: () ->
    options = { reset: true }
    $input = @$(@suggest_input)
    query  = $input.val()

    options.data = { q: query } if query.length

    @collection.fetch(options)

  # Renders
  render: ->
    @$el.html(@template(category: @model, show_form: @show_form))

    this

  renderIndex: ->
    @categoriesIndex = view = new Aircrm.Views.CategoriesIndex(collection: @collection)
    $(".category_index").replaceWith(view.render().el)

    this
