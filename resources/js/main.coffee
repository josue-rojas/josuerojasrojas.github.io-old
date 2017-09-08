---
---

# check mobile (only after dom is loaded)
isMobile = ->
  return $('.mobilecheck').css('display')=='none'

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
  # smooth fade
  # SHOULD MOVE THIS OUT CAUSE IT IS BEING REPEATED
  $(displayOn).fadeOut(300,->
    $filterTemp = $('.filterTemp')
    $filterTemp.html('')
    $filterTemp.append(insertHTML)
    $filterTemp.fadeIn(400)
    displayOn = '.filterTemp'
    )


window.sortName = ->
  repos = $(displayOn).find('.repo')
  selectNames = ((displayOn+" [data-name='"+$(repo).data('name')+"']") for repo in repos).reverse()
  insertHTML = makeRows(selectNames)
  $(displayOn).fadeOut(300,->
    $filterTemp = $('.filterTemp')
    $filterTemp.html('')
    $filterTemp.append(insertHTML)
    $filterTemp.fadeIn(400)
    displayOn = '.filterTemp'
    )
