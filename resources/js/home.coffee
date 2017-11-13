---
---
# home coffee, duh...
# NEED TO CUT OUT REPETIVENESS (MORE especifically CHANGING OF SLIDES)
hasTouch = false
document.addEventListener "DOMContentLoaded", ->
  try
    document.createEvent('TouchEvent')
    hasTouch = true
  catch error
    hasTouch = false
    $('.controls-box').removeClass('hasHover')

  controlActive = false
  if hasTouch
    $('.controls').click ->
      if !controlActive
        $('.control-box').addClass('active')
        controlActive = true
      else
        $('.control-box').removeClass('active')
        controlActive = false
  $('.btn').click (e)->
    e.stopPropagation();

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
      textDelay = if letter == ' ' then textDelay+50 else textDelay+300
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

  # var for change slides
  slides = $('.slide')
  endSlide = slides.length-1
  prevSlide = 0
  currSlide = 0

  # THIS FUNCION SHOULD BECOME MAIN CHANGER
  window.changeTo = (slideNum=-1, direction=0) ->
    if !canChange
      return
    slideNum = if slideNum != -1 then slideNum else direction + currSlide
    # if slideNum == -1
    #   slideNum = direction + currSlide
    #   console.log(currSlide+direction == currSlide)
    #   console.log(direction + ' next ' + currSlide+direction + ' curr ' + currSlide)
    console.log(slideNum)
    if slideNum < 0
      console.log('slideNum < 0')
      return
    else if slideNum == endSlide+1
      console.log('== en+1')
      return
    else if prevSlide == slideNum
      console.log('==slidenum')
      return
    barUpdate()
    $(slides[prevSlide]).removeClass('active')
    change = (slideNum, direction)->
      currSlide = if direction == 0 then slideNum else currSlide+direction
      $(slides[currSlide]).addClass('active')
      prevSlide = currSlide
      if currSlide == 0
        runFirst()
    setTimeout(change, 1500, slideNum, direction)

  $(window).keydown (e)->
    if canChange
      if e.which == 38
        changeTo(-1, -1)
      else if e.which == 40
        changeTo(-1, 1)

  isScrolling = false
  scrollTimeOut = ''
  direction = 0
  tot = 0
  yesScroll = ->
    console.log('directn' + direction)
    if direction < 0
      changeTo(-1, -1)
    else
      changeTo(-1, 1)
    tot = 0
    direction = 0


  $(window).scroll (event)->
    console.log($(this).scrollTop())
    if canChange
      if tot < 5
        tot++
        console.log('total', tot)
        direction+=$(this).scrollTop()
      clearTimeout(scrollTimeOut)
      if tot == 5 #make sure get more than one number
        isScrolling = false
        scrollTimeOut = setTimeout(yesScroll, 100)
