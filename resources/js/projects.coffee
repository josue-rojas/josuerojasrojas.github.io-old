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
        # be able to click buttons....
        if $(event.target).is($('.button'))
          return
        $repo = $(event.target).closest('.repo')
        if $repo.hasClass('buttonToggle')
          $repo.removeClass('buttonToggle')
        else
          $('.buttonToggle').removeClass('buttonToggle')
          $repo.addClass('buttonToggle')
  repoMobileTogg('.main.filter')
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
  console.log(displayOn)
  $(displayOn).fadeOut(300,->
    displayOn = '.filterTemp'
    $filterTemp = $(displayOn)
    $filterTemp.html('')
    $filterTemp.append(insertHTML)
    repoMobileTogg(displayOn)
    $filterTemp.fadeIn(400)
    )


# filter for languages
window.filterLanguage = (language) ->
  # show all
  if language == 'repo'
    $(displayOn).fadeOut(300, ->
      $('.main.filter').fadeIn(400)
      displayOn = '.main.filter'
      )
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
