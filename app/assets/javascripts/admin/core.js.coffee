# Some general UI pack related JS
# Extend JS String with repeat method
String::repeat = (num) ->
  new Array(num + 1).join this

# Depth string
  # params:
  #   remove_root  remove first element (default: false)
  # Ex:
  #   "item[name][first]".point()       => "item.name.first"
  #   "item[name][first][]".point()     => "item.name.first[]"
  #   "item[name][first][]".point(true) => "name.first[]"
String::depth = (remove_root = false) ->
  # split
  # splited = this.match(/(?!\[)[^\[\]]{1,}/g)
  splited = this.match(/(?!\[)[^\[\]]{1,}|\[\d\]/g)
  splited.shift() if remove_root

  # join
  joined = splited.join('.')
  joined = joined.concat('[]') if /\[\]$/.test(this)
  joined = joined.replace(/\.\[/g, '[')

  # return
  joined


# Form Reset
jQuery.fn.reset = ->
  $(this).each ->
    $.isFunction(@reset) and @reset()

# Add segments to a slider
$.fn.addSliderSegments = (amount, orientation) ->
  @each ->
    if orientation is "vertical"
      output = ""
      i = undefined
      i = 1
      while i <= amount - 2
        output += "<div class=\"ui-slider-segment\" style=\"top:" + 100 / (amount - 1) * i + "%;\"></div>"
        i++
      $(this).prepend output
    else
      segmentGap = 100 / (amount - 1) + "%"
      segment = "<div class=\"ui-slider-segment\" style=\"margin-left: " + segmentGap + ";\"></div>"
      $(this).prepend segment.repeat(amount - 2)
    return

# Insert jquery element in specific index
$.fn.insertAt = (index, $parent) ->
  @each ->
    if index is 0
      $parent.prepend this
    else
      $parent.children().eq(index - 1).after this
    return

window.AIRCRM =
  before: ->
    console.log "[before] Executed in every single page!"

    AIRCRM.Admin.init()

    return

  after: ->
    console.log "[after] Executed in every single page!"
    return


  # Core Functions
  Admin: ( (document, window, $) ->
    # Run in page:load
    init    = (ev) ->

      # Constructores
      @time()
      @bootstrap()
      @scrollbar()
      @countUP()
      @sidebar()
      @widget()

      return


    ### Constructors ###
    # Bootstrap
    bootstrap = ->
      # Carregamento sobre demanda das imagens
      $("img.lazy").show().lazyload
        threshold: 200
        effect: "fadeIn"

      # popovers and tooltips
      $("a[rel~=popover], .has-popover, .popovers").popover()
      $("a[rel~=tooltip], .has-tooltip, .tooltips").tooltip()

      # collapse
      $('.collapse').collapse()

      # Fancybox
      $(".fancybox").fancybox();

      # Spinners
      $('.spinbox').spinbox();


    # Sidebar
    sidebar   = ->
      #  sidebar toggle
      responsiveView = ->
        wSize = $(window).width()
        if wSize <= 768
          $("#container").addClass "sidebar-close"
          $("#sidebar > ul").hide()
        if wSize > 768
          $("#container").removeClass "sidebar-close"
          $("#sidebar > ul").show()
        return

      # nav-accordion
      $("#nav-accordion").dcAccordion
        eventType: "click"
        # autoClose: false
        saveState: true
        # disableLink: false
        # speed: "slow"
        showCount: false
        autoExpand: true

        #        cookie: 'dcjq-accordion-1',
        classExpand: "dcjq-current-parent"

      _location = window.location
      active_href_selector = "[href='#{_location.pathname}'], [href='#{_location.href}']"
      $("#nav-accordion").find(active_href_selector).each((index) ->
        $(this).closest("li").addClass("active")
      )

      #  sidebar dropdown menu auto scrolling
      $("#sidebar .sub-menu > a").off(".sidebar").on "click.sidebar", (event) ->
        o = ($(this).offset())
        diff = 250 - o.top
        if diff > 0
          $("#sidebar").scrollTo "-=" + Math.abs(diff), 500
        else
          $("#sidebar").scrollTo "+=" + Math.abs(diff), 500
        return

      # Sidebar toggle button
      $(".fa-bars").off(".sidebar").on "click.sidebar", (event) ->
        if $("#sidebar > ul").is(":visible") is true
          $("#main-content" ).css "margin-left": "0px"
          $("#sidebar"      ).css "margin-left": "-210px"
          $("#sidebar > ul" ).hide()
          $("#container"    ).addClass "sidebar-closed"
        else
          $("#main-content" ).css "margin-left": "210px"
          $("#sidebar > ul" ).show()
          $("#sidebar"      ).css "margin-left": "0"
          $("#container"    ).removeClass "sidebar-closed"
        return


      $(window).off(".sidebar").on "resize.sidebar", responsiveView
      responsiveView()

    # Scrollbar
    scrollbar   = ->
      scroll_options =
        styler: "fb"
        cursorcolor: "#e8403f"
        cursorborderradius: "10px"
        background: "#404040"
        spacebarenabled: false
        # cursorwidth: "3"
        cursorwidth: "6"
        cursorborder: ""

      $(".nice-scroll").niceScroll $.extend({}, scroll_options)

      # $("body").niceScroll $.extend({}, scroll_options,
      #   # cursorwidth: "6"
      #   zindex: "1000"
      # )

    # Moment time constructor format datetime
    time    = ->
      $("time.unloaded").each (i) ->
        $this = $(this).removeClass("unloaded")
        dt = new Date($this.attr("datetime"))
        unless isNaN(dt)
          m = moment(dt)
          $this.html(m.fromNow()).attr "title", m.format("LLLL")

    # Count UP effect
    countUP = ->
      $(".count-up").each (i) ->
        $this     = $(this).removeClass("count-up")
        startVal  = $this.data("start")
        endVal    = $this.text()

        options =
          useEasing : false
          useGrouping : true
          separator : '.'
          decimal : ','

        decimals = 0
        duration = 2

        demo = new countUp(this, startVal, endVal, decimals, duration, options)
        demo.start()
        # return true

    widget = ->
      $(".panel .tools")
        .find(".fa-chevron-down").click( ->
         el = $(this).closest(".panel").children(".panel-body")
         console.debug "el", el, $(this), $(this).parents(".panel")
         if $(this).hasClass("fa-chevron-down")
           $(this).removeClass("fa-chevron-down").addClass "fa-chevron-up"
           el.slideUp 200
         else
           $(this).removeClass("fa-chevron-up").addClass "fa-chevron-down"
           el.slideDown 200
        ).end()
        .find(".fa-times").click ->
          $(this).closest(".panel").remove()
          # $(this).closest(".panel").parent().remove()

    {
      init:     init
      # Constructors
      bootstrap:      bootstrap
      countUP:        countUP
      sidebar:        sidebar
      scrollbar:      scrollbar
      time:           time
      widget:         widget
    }
  )(document, window, jQuery)

# Page load with Dispatcher
window.ready = (ev) ->
  Dispatcher.init(AIRCRM)

$(document).ready(ready)
$(document).on('page:load', -> ready )
