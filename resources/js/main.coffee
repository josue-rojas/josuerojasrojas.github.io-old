---
---
'''
this file should contain defaults scripts for all pages
'''

document.addEventListener "DOMContentLoaded", ->
  # -----------------------------------------
  # footer reposition when window resize 
  state = true
  window.footerReposition = ->
    $footer = $('.footer')
    if ($('body').height()+ $footer.outerHeight() + $footer.height() > $(window).outerHeight())
      if state
        $footer.fadeOut 300, ->
          $footer.addClass 'content-footer'
          $footer.fadeIn 400
        state = false
    else
      if !state
        $footer.fadeOut 300, ->
          $footer.removeClass 'content-footer'
          $footer.fadeIn 400
        state = true

  footerReposition()
  $(window).resize(footerReposition)
