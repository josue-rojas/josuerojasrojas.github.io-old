---
---
'''
this file is only used and should only be loaded in projects page
'''
hasTouch = false
# check mobile (only after dom is loaded)
isMobile = ->
  return $('.mobilecheck').css('display')=='none'
# better check for mobile (checks if touch)
document.addEventListener("DOMContentLoaded", ->
  # ---------------------------------------------------
  # check if it has touch (mobile)
  try
    document.createEvent('TouchEvent')
    document.documentElement.className += " touch"
    hasTouch = true
  catch error
    document.documentElement.className += " no-touch"
  # ---------------------------------------------------
  # slide show thingy for languages showing
  currentLang = 0
  timoutLangChange = ''
  window.languageInfo = ($languages)->
    totalLangs = $languages.length
    $languages.css('display','none')
    if totalLangs <= currentLang
      currentLang = 0
    $curLang = $($languages[currentLang++])
    $('.active').removeClass('active')
    $curLang.closest('.repo').find('*[data-language="'+$curLang.data('language')+ '"]').addClass('active')
    $curLang.fadeIn(300).css('display', 'flex')
    timoutLangChange = if totalLangs > 1 then setTimeout(languageInfo, 2500, $languages) else ''
    return
    # functions for entering and exiting hover
  enterHover = (event) ->
    $languages = $(event.target).closest('.repo').find('.language-info').sort (a,b) ->
      return $(a).data('order') - $(b).data('order')
    if $languages.length > 0
      languageInfo($languages)
  exitHover = ->
    currentLang = 0
    clearTimeout(timoutLangChange)
  # enable the languages showing on hover
  window.languageShow = (display) ->
      return if hasTouch then false else $(display + ' .repo').hover(enterHover, exitHover)
  languageShow('.main.filter')

  # ---------------------------------------------------
  # toggle for mobile (removes hover)
  window.repoMobileTogg = (display) ->
    if hasTouch
      $('.repo').removeClass('repoHover')
      $(display + ' .repo').on 'touchend',(event) ->
        $event = event
        $repo = $(event.target).closest('.repo')
        $hoverCont = $repo.find('.hover-container')
        if $repo.hasClass('buttonToggle')
          exitHover()
          $hoverCont.fadeOut 150, ->
            $hoverCont.find('.language-info').css('display','none') # removes stutter (need a better way)
            $repo.removeClass('buttonToggle')
        else
          $currentOn = $('.buttonToggle')
          if $currentOn.length > 0
            exitHover()
            $currentOn.find('.hover-container').fadeOut 150, ->
              $currentOn.removeClass('buttonToggle')
              $currentOn.find('.language-info').css('display','none') # removes stutter (need a better way)
              $repo.addClass('buttonToggle')
              $hoverCont.fadeIn 400, ->
                enterHover($event)
                $hoverCont.css('display','flex')
          else
            $repo.addClass('buttonToggle')
            $hoverCont.fadeIn 400, ->
              enterHover($event)
              $hoverCont.css('display','flex')
      # fix the links not working when clicked on images...
      $(display+' .repo .hover-container a').on 'touchend', (event) ->
        event.stopPropagation()
  repoMobileTogg('.main.filter')

  # ---------------------------------------------------
  # toggle for navbar on mobile (probably could be shorter)
  prevToggle = 'none' # stores which toogle is active, start with none
  $('.navbar-toggler').click (event)->
    $thisID = $(event.target).closest('.navbar-toggler').attr('id')
    if prevToggle != $thisID and !$('#'+prevToggle).hasClass('collapsed')
      $('#'+prevToggle).trigger('click')
    prevToggle = $thisID
)


# make rows for filters/sorting
makeRows = (selectors) ->
    i = 0
    insertHTML = ''
    last = selectors.length
    # create the new rows
    for single in selectors
      selectHTML = $("<div />").append($(single).clone()).html()
      # first column and start of row
      if i%3 == 0
        insertHTML += ('<div class="row">
        <div class="col-md-2 side-col"></div>' + selectHTML)
      # second column
      else if i%3 == 1
        insertHTML += ('<div class="col-md-1"> </div>'+ selectHTML + '<div class="col-md-1"></div>')
      # thirs column
      else if i%3 == 2
        insertHTML += (selectHTML + '<div class="col-md-2 side-col"></div>')
      # close the row
      if i == last or i%3 == 2
        insertHTML += '</div>'
      i++
    return insertHTML


displayOn = '.main.filter' # holds which filter is on
# stuff to do when fading the display for filter ot sorting (#smoothfade)(depends on displayOn created before function)
fadeFilter = (insertHTML) ->
  $(displayOn).fadeOut 300, ->
    displayOn = '.filterTemp'
    $filterTemp = $(displayOn)
    $filterTemp.html('')
    $filterTemp.append(insertHTML)
    repoMobileTogg(displayOn)
    languageShow(displayOn)
    $filterTemp.fadeIn 400, ->
      # risky cause this doesnt exist only after dom
      footerReposition()



# filter for languages
window.filterLanguage = (language) ->
  # show all
  if language == 'repo'
    $(displayOn).fadeOut 300, ->
      $('.main.filter').fadeIn 400, ->
        # risky cause this doesnt exist only after dom
        footerReposition()
        # $('footer').fadeOut 300, ->
        #   $('footer').fadeIn 400, ->
      displayOn = '.main.filter'

    return
  insertHTML = makeRows($('.main.filter').find('.repo.'+language))
  fadeFilter(insertHTML)

reverse = false
prevType = ''
window.sortRepos = (type) ->
  repos = $(displayOn).find('.repo')
  selectNames = ((displayOn+" [data-" + type + "='"+$(repo).data(type)+"']") for repo in repos).sort()
  # toogle reverse MIGHT NEED TO CHANGE THIS, IT'S A BIT CONFUSING
  if reverse and type == prevType
     selectNames.reverse()
  else
    reverse = false
  reverse = !reverse
  prevType = type
  insertHTML = makeRows(selectNames)
  fadeFilter(insertHTML)
