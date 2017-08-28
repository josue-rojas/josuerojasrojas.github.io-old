---
---
# need to find a smoother way to fade in and out
window.filterLanguage = (language) ->
  repos = $('.repo')
  i = 0
  last = repos.length
  for repo in repos
    i++
    if i == last
      $(repo).fadeOut(200,->
        $('.repo.'+language).fadeIn(600)
      )
    else
      $(repo).fadeOut(200)
