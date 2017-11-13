---
---
# home coffee, duh...

document.addEventListener "DOMContentLoaded", ->

  currVal = 0
  canChange = false
  textDelay = 500
  isFirst=true
  blinkTimeout = ''

  control = ->
    $('.control-box.first').removeClass('first')
  setTimeout(control, 3600)
  # progress bar
  barUpdate=(change=1)->
    if currVal == 180
      canChange = true
      currVal = 0
      $('#loadingBar').attr('value', currVal)
      return
    canChange=false
    setTimeout(barUpdate, 20)
    $('#loadingBar').attr('value', currVal++)
  # barUpdate()

  # intro
  runFirst=->
    # if !isFirst
    #   clearTimeout(blinkTimeout) # stop waisting precious resource, like this comment
    #   return
    word = ''
    for letter in 'Hello World....'
      word+=letter
      f = (word)->
        $('.slide.intro .text').text(word)
      setTimeout(f, textDelay, word)
      textDelay = if letter == ' ' then textDelay+100 else textDelay+500
    textDelay = 0
    blinking = false;
    blink = ->
      blinkTimeout = setTimeout(blink, 500)
      if blinking
        $('.blinker').removeClass('blinking')
        blinking = false
        return
      $('.blinker').addClass('blinking')
      blinking = true
    blink()

  # first start
  runFirst()
  barUpdate()

  slides = $('.slide')
  endSlide = slides.length-1
  prevSlide = 0
  currSlide = 0
  $(window).keydown (e)->
    if canChange
      if e.which == 38
        if currSlide == 0
          return
        barUpdate()
        $(slides[prevSlide]).removeClass('active')
        change=->
          $(slides[--currSlide]).addClass('active')
          prevSlide = currSlide
          if currSlide == 0
            runFirst()
        setTimeout(change, 1500)
        prevSlide = currSlide
      else if e.which == 40
        if currSlide == endSlide
          return
        barUpdate()
        $(slides[prevSlide]).removeClass('active')
        change=->
           $(slides[++currSlide]).addClass('active')
           prevSlide = currSlide
        setTimeout(change, 1500)
        
  window.changeTo = (slideNum) ->
    $(slides[prevSlide]).removeClass('active')
    currSlide = slideNum
    change=->
      $(slides[currSlide]).addClass('active')
      prevSlide = currSlide
      if currSlide == 0
        runFirst()
    setTimeout(change, 1500)
