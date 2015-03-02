###
#
#    countUp.js
#    by @inorganik
#    v 1.1.2
#
# Example:
# numAnim = new countUp "SomeElementYouWantToAnimate", 0, 99.99, 2, 2.5
# numAnim.start()
# with optional callback;
# numAnim.start someMethodToCallOnComplete
###

# target = id of html element or var of previously selected html element where counting occurs
# startVal = the value you want to begin at
# endVal = the value you want to arrive at
# decimals = number of decimal places, default 0
# duration = duration of animation in seconds, default 2
# options = optional object of options (see below)

window.countUp = (target, startVal, endVal, decimals, duration, options) ->

  # default options
  @options = $.extend({},
    useEasing: true # toggle easing
    useGrouping: true # 1,000,000 vs 1000000
    separator: ',' # character to use as a separator
    decimal: '.' # character to use as a decimal
  , options)

  if @options.separator == '' then @options.useGrouping = false;


  # make sure requestAnimationFrame and cancelAnimationFrame are defined
  # polyfill for browsers without native support
  # by Opera engineer Erik Möller
  lastTime = 0
  vendors = [
    "webkit"
    "moz"
    "ms"
  ]
  x = 0

  while x < vendors.length and not window.requestAnimationFrame
    window.requestAnimationFrame = window[vendors[x] + "RequestAnimationFrame"]
    window.cancelAnimationFrame = window[vendors[x] + "CancelAnimationFrame"] or window[vendors[x] + "CancelRequestAnimationFrame"]
    ++x

  unless window.requestAnimationFrame
    window.requestAnimationFrame = (callback, element) ->
      currTime = new Date().getTime()
      timeToCall = Math.max 0, 16 - (currTime - lastTime)

      id = window.setTimeout(->
        callback currTime + timeToCall
      , timeToCall)

      lastTime = currTime + timeToCall
      id

  unless window.cancelAnimationFrame
    window.cancelAnimationFrame = (id) ->
      clearTimeout id

  @options.useGrouping = false if @options.separator is ""
  self        = this
  @d          = (if (typeof target is "string") then document.getElementById(target) else target)
  @startVal   = Number(startVal) || 0
  @endVal     = Number(endVal) || 0
  @countDown  = (if (@startVal > @endVal) then true else false)
  @startTime  = null
  @timestamp  = null
  @remaining  = null
  @frameVal   = @startVal
  @rAF        = null
  @decimals   = Math.max(0, decimals or 0)
  @dec        = Math.pow(10, @decimals)
  @duration   = duration * 1000 or 2000
  @version    = ->
    "1.1.2"

  # Robert Penner's easeOutExpo
  @easeOutExpo = (t, b, c, d) ->
    c * (-Math.pow(2, -10 * t / d) + 1) * 1024 / 1023 + b

  @count = (timestamp) =>
    @startTime  = timestamp if @startTime is null
    @timestamp  = timestamp
    progress    = timestamp - @startTime
    @remaining  = @duration - progress

    # to ease or not to ease
    if @options.useEasing
      if @countDown
        i = @easeOutExpo progress, 0, @startVal - @endVal, @duration
        @frameVal = @startVal - i
      else
        @frameVal = @easeOutExpo(progress, @startVal, @endVal - @startVal, @duration)
    else
      if @countDown
        i = (@startVal - @endVal) * (progress / @duration)
        @frameVal = @startVal - i
      else
        @frameVal = @startVal + (@endVal - @startVal) * (progress / @duration)

    # decimal
    @frameVal = Math.round(@frameVal * @dec) / @dec

    # don't go past endVal since progress can exceed duration in the last frame
    if @countDown
      @frameVal = if (@framVal < @endVal) then @endVal else @frameVal
    else
      @frameVal = if (@framVal > @endVal) then @endVal else @frameVal

    # format and print value
    @d.innerHTML = @formatNumber @frameVal.toFixed(@decimals)

    # whether to continue
    if progress < @duration
      @rAF = requestAnimationFrame @count
    else
      @callback() if @callback?

  @start = (callback) ->
    @callback = callback
    # make sure values are valid
    if not isNaN(@endVal) and not isNaN(@startVal)
      @rAF = requestAnimationFrame(@count)
    else
      console.log "countUp error: startVal or endVal is not a number"
      @d.innerHTML = "--"
    true

  @stop = ->
    cancelAnimationFrame @rAF
    true

  @reset = ->
    @startTime = null
    @startVal = startVal
    cancelAnimationFrame @rAF
    @d.innerHTML = @formatNumber(@startVal.toFixed(@decimals))
    true

  @resume = ->
    @startTime = null
    @duration = @remaining
    @startVal = @frameVal
    requestAnimationFrame @count
    true

  @formatNumber = (nStr) ->
    nStr += ""
    x = undefined
    x1 = undefined
    x2 = undefined
    rgx = undefined
    x = nStr.split(".")
    x1 = x[0]
    x2 = (if x.length > 1 then @options.decimal + x[1] else "")
    rgx = /(\d+)(\d{3})/
    x1 = x1.replace(rgx, "$1" + @options.separator + "$2")  while rgx.test(x1)  if @options.useGrouping
    x1 + x2


  # format startVal on initialization
  @d.innerHTML = @formatNumber(@startVal.toFixed(@decimals))
