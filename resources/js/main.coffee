---
---
#WITH THE LATEST CHANGE THIS DOESNT FUNCTION
# need to find a smoother way to fade in and out
# window.filterLanguage = (language) ->
#   repos = $('.repo')
#   i = 0
#   last = repos.length
#   for repo in repos
#     i++
#     if i == last
#       $(repo).fadeOut(200,->
#         $('.repo.'+language).fadeIn(600)
#       )
#     else
#       $(repo).fadeOut(200)

# new idea:
# make a temp div box with rows that match the current view
# insert in those rows the ones that we are goint to show
# when show all just hide that box and show the others
# might need 2 for one switching from one filter to the other
