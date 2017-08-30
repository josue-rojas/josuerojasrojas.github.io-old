---
---

# check mobile (only after dom is loaded)
isMobile = ->
  return $('.mobilecheck').css('display')=='none'


displayOn = '.main.filter' # holds which filter is on

# filter for languages
window.filterLanguage = (language) ->
  # show all
  if language == 'repo'
    $(displayOn).fadeOut(300, ->
      $('.main.filter').fadeIn(400)
      displayOn = '.main.filter'
      )
    return


  i = 0
  insertHTML = ''
  repos = $('.main.filter').find('.repo.'+language)
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

  # smooth fade
  $(displayOn).fadeOut(300,->
    $filterTemp = $('.filterTemp')
    $filterTemp.html('')
    $filterTemp.append(insertHTML)
    $filterTemp.fadeIn(400)
    displayOn = '.filterTemp'
    )
