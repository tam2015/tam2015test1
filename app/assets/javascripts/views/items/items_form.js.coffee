class Aircrm.Views.ItemsForm extends Backbone.View

  @options: {}

  template: JST['items/form']
  templateAttributes: JST['items/form_attributes']
  templateVariation: JST['items/form_variation']

  dropZoneIndex: 0

  el: '.form_mercadolibre_item'
  container: '<div class="item-container" />'

  events:
    # listen input changes
    'change input[name^="item"]': 'changeInput'


  initialize: (args) ->
    args || (args = {});

    @collection = new Aircrm.Collections.Items() unless @collection

    @attachModelEvents()

    @initialized = true
    @afterInitialize()
    this

  afterInitialize: (args) ->
    @render()
    @renderAttributes()

    this

  attachModelEvents: () ->
    @model.on('sync', @afterInitialize, this)

    @model.on('change:category_id'  , @model.changeCategoryId, @model)
    @model.on('change:category_id'  , @renderAttributes, this)
    @model.on('change:category_id'  , @render, this)
    @model.on('change:shipping.mode', @render, this)


  # Events
  changeInput: (event) ->
    target = event.currentTarget

    # normalize key withou root_name (item)
    key   = target.name.depth(true)
    value = target.value

    # if key ended with array
    if /\[\]$/.test(key)
      key   = key.replace(/\[\]$/, '')
      values = [ value ]

      if /checkbox/i.test(target.type)
        values = @model.get(key) || []
        if target.checked
          values.push(value)
        else
          values = _.without(values, value)

      value = values


    @model.set(key, value)

  # Renders
  render: ->
    @$container = $(@container)
    @$container.html(@template(item: @model))

    @$el.find(".conditions-container"         ).replaceWith(@$container.find(".conditions-container"          ))
    @$el.find(".payment_methods-container"    ).replaceWith(@$container.find(".payment_methods-container"     ))
    @$el.find(".shipping-container"           ).replaceWith(@$container.find(".shipping-container"            ))
    @$el.find(".shipping-dimensions-container").replaceWith(@$container.find(".shipping-dimensions-container" ))

    if @model.category and @model.category.id
      @$(".depends_category").removeClass("hidden")
    else
      @$(".depends_category").addClass("hidden")

    this

  renderAttributes: ->
    $attributes_container = @$el.find(".attributes-container")
    $variations_container = @$el.find(".variations-container")

    # Clean variations container
    $variations_container.html('')

    if @model.category
      if @model.category.get("attribute_types") == "variations"
        url = 'https://api.mercadolibre.com/categories/' + @model.category.id + '/attributes'

        $.getJSON(url, (data) =>
          # Attributes
          # GENDER => Gender
          # SEASON => Season
          attributes = []

          # Variations
          # 63000 => Size
          # 33000 => Color Primary
          # 43000 => Color Secundary
          variations = {}

          _.each(data, (attribute) =>
            if attribute.tags and attribute.tags and attribute.tags.allow_variations
              variations[attribute.id] = attribute
            else
              attributes.push(attribute)

            @model.category._variations = variations
            @model.category._attributes = attributes
          )

          $attributes_container.html(@templateAttributes(item: @model, attributes: attributes))
          @renderVariations()
        )
      else
        $attributes_container.html('')
        $('.item_available_quantity').removeClass("hidden")

        pictures = @model.get("pictures")
        dropzone_pictures = document.querySelector(".item_picture_ids .dropzone.picture_ids")

        if dropzone_pictures and !dropzone_pictures.dropzone
          @renderDropPictures(pictures)

  renderVariations: ->
    if variation_attributes = @model.category._variations
      $variations_container = @$el.find(".variations-container")
      $variations_container.append(@templateVariation(item: @model, variation_attributes: variation_attributes))

      (@model.get("variations") || [{}]).map((variation, index) =>
        variation_pictures = []
        pictures = @model.get("pictures")

        if variation.picture_ids and pictures
          variation_pictures = pictures.filter((picture) =>
            _.contains(variation.picture_ids, picture._id.$oid)
          )

        @renderDropPictures(variation_pictures, variation_index)
      )

  renderDropPictures: (pictures, variation_index) ->
    pictures ||= []
    dropZoneName = "myDropzone_#{@dropZoneIndex}"
    class_inner  = if (variation_index) then "variations_#{variation_index}_" else ""

    myDropzone = new Dropzone(".item_#{class_inner}picture_ids .dropzone.picture_ids", {
      url           : "#{@model.url()}/pictures"
      acceptedFiles : "image/*"
      maxFiles      : 6
      addRemoveLinks: true
      paramName     : "pictures" # The name that will be used to transfer the file

      init: ->
        thisDropzone = this

        pictures.map((picture) ->
          mockFile = {
            name: (picture.filename || picture._id.$oid)
            size: picture.size
          }

          # - See more at: http://www.startutorial.com/articles/view/dropzonejs-php-how-to-display-existing-files-on-server#sthash.5lDXCi3D.dpuf
          thisDropzone.options.addedfile.call(thisDropzone, mockFile);
          thisDropzone.options.thumbnail.call(thisDropzone, mockFile, picture.image.thumb.url);
        )
    })

    myDropzone.on("sending", (file, xhr, formData) =>
      if variation_index
        formData.append("variation_index", index)
    )
    @dropZoneIndex++
    window[dropZoneName] = myDropzone
