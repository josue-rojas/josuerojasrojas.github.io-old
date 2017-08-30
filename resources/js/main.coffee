---
---

# check mobile (only after dom is loaded)
isMobile = ->
  return $('.mobilecheck').css('display')=='none'


filterFilled = '.filterTemp2'

# should reduce this to have only one temp instead of swithing back and forth
window.filterLanguage = (language) ->
  # show all
  if language == 'repo'
    $('.main').fadeOut(400, ->
      $('.main.filter').fadeIn(500)
      )
    return

  #filter switching
  filterFilled = if filterFilled == '.filterTemp2' then '.filterTemp1' else '.filterTemp2'
  # clear the html to have no repetition
  $('.filterTemp1').html('')
  $('.filterTemp2').html('')
  i = 0
  insertHTML = ''
  repos = $('.repo.'+language) # this could have gotten the repetition
  last = repos.length
  # create the new rows
  for repo in repos
    repoHTML = $("<div />").append($(repo).clone()).html()
    # first column and start of row
    if i%3 == 0
      insertHTML += ('<div class="row">
      <div class="col-md-2 side-col"></div>' + repoHTML)
    # second column
    else if i%3 == 1
      insertHTML += ('<div class="col-md-1"> </div>'+ repoHTML + '<div class="col-md-1"></div>')
    # thirs column
    else if i%3 == 2
      insertHTML += (repoHTML + '<div class="col-md-2 side-col"></div>')
    # close the row
    if i == last or i%3 == 2
      insertHTML += '</div>'
    i++
  $(filterFilled).append(insertHTML)

  #smoother fade maybe just fade the one that is not display none
  j = 0
  mains = $('.main')
  lastMain = mains.length-1
  for main in mains
    if j == lastMain
      $(main).fadeOut(400, ->
        $(filterFilled).fadeIn(500)
      )
    else
      $('.main').fadeOut(100)
    j++
