---
---
window.filterLanguage = (language) ->
  for repo in $('.repo')
    $(repo).hide(300)
    if $(repo).hasClass(language)
      $(repo).show(500)
    else
      $(repo).hide(500)
