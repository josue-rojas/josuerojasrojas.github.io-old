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
  try
    document.createEvent('TouchEvent')
    document.documentElement.className += " touch"
    hasTouch = true
  catch error
    document.documentElement.className += " no-touch"

  # toggle for mobile (removes hover)
  window.repoMobileTogg = (display) ->
    if hasTouch
      $('.repo').removeClass('repoHover')
      $(display + ' .repo').on 'touchend',(event) ->
        $repo = $(event.target).closest('.repo')
        $hoverCont = $repo.find('.hover-container')
        if $repo.hasClass('buttonToggle')
          $hoverCont.fadeOut 150, ->
            $repo.removeClass('buttonToggle')

        else
          $currentOn = $('.buttonToggle')
          if $currentOn.length > 0
            $currentOn.find('.hover-container').fadeOut 150, ->
              $currentOn.removeClass('buttonToggle')
              $repo.addClass('buttonToggle')
              $hoverCont.fadeIn(400).css('display','flex')
          else
            $repo.addClass('buttonToggle')
            $hoverCont.fadeIn(400).css('display','flex')
      # fix the links not working when clicked on images...
      $(display+' .repo .hover-container a').on 'touchend', (event) ->
        event.stopPropagation()
  repoMobileTogg('.main.filter')

  # slide show thingy for languages showing
  currentLang = 0
  hover = false
  changeLang = ''
  window.languageInfo = ($languages)->
    if !hover
      return
    console.log('hellooooo')
    totalLangs = $languages.length
    if totalLangs > 1
      for lang in $languages
        $(lang).fadeOut(0)
      currentLang++
      if totalLangs <= currentLang
        currentLang = 0
    # console.log(hover)
    # console.log($($languages[currentLang]))
    $($languages[currentLang]).fadeIn(300).css('display', 'flex')
    if hover
      console.log('hellohihihih')
      changeLang = setTimeout(languageInfo, 2000, $languages)
      # setInterval(languageInfo($languages), 2000)
    return

  enterHover = (event) ->
    console.log(hover)
    $languages = $(event.target).closest('.repo.repoHover').find('.language-info')
    console.log('hellloww')
    if $languages.length > 0
      hover = true
      languageInfo($languages)
    # return
  exitHover = ->
    currentLang = 0
    console.log('exitt')
    clearTimeout(changeLang)
    hover = false
  $('.repo.repoHover').hover(enterHover, exitHover)

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
    $filterTemp.fadeIn(400)



# filter for languages
window.filterLanguage = (language) ->
  # show all
  if language == 'repo'
    $(displayOn).fadeOut 300, ->
      $('.main.filter').fadeIn(400)
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
