$(document).ready ->
  if $(".vtrg-add-new-wrapper").length

    event_provider = $(".vtrg-add-new-wrapper")

    toggleEditorBlocker = ($editWrapper, act) ->
      $editWrapper.toggleClass 'blocked', act

    # --- # --- VIEW --- # --- #
    restoreViewState = ($editWrapper, viewdata) ->
      if viewdata
        $editWrapper.removeClass "editmode"
        $editWrapper.children(".vtrg-edit-body").html viewdata
        toggleEditorBlocker $editWrapper, false
        event_provider.trigger "vitrageshowed", [ $editWrapper[0] ]
      else
        $.ajax
          url: "/vitrage/pieces/" + $editWrapper.data("id")
          # type: "GET"
          dataType: "html"
          success: (data, textStatus, jqXHR) ->
            restoreViewState $editWrapper, data
          # error: null

    # --- # --- UPDATE and cancel editing --- # --- #
    coverEditFormActions = ($editWrapper) ->
      # cover Submit action
      $blockForm = $editWrapper.find('form')

      $blockForm.on "ajax:before", ->
        toggleEditorBlocker $editWrapper, true
        return true # do your work buddy

      $blockForm.on "ajax:success", (evnt, data, textStatus, jqXHR) ->
        event_provider.trigger "vitrageupdated"
        restoreViewState $(@).closest(".vtrg-edit-wrapper"), data
      # $blockForm.on "ajax:error"
      # $blockForm.on "ajax:complete"


      # cover Cancel action
      $editWrapper.find('form .actions a').click (evnt) ->
        $clickedAnchor = $(@)
        clickedAnchorParentID = $clickedAnchor.parent().attr("id")
        if clickedAnchorParentID && clickedAnchorParentID.substr(clickedAnchorParentID.length - 13) == "cancel_action"
          evnt.preventDefault()
          toggleEditorBlocker $editWrapper, true
          restoreViewState $editWrapper
          return false

    # --- # --- EDIT --- # --- #
    initEditControl = (wrappers) ->
      wrappers.find(".vtrg-edit-control a[rel=edit]").click (evnt) ->
        evnt.preventDefault()
        $editWrapper = $(@).closest(".vtrg-edit-wrapper")
        toggleEditorBlocker $editWrapper, true
        $.ajax
          url: "/vitrage/pieces/" + $editWrapper.data("id") + "/edit"
          # type: "GET"
          dataType: "html"
          success: (data, textStatus, jqXHR) ->
            $editWrapper.addClass "editmode"
            $editWrapper.children(".vtrg-edit-body").html data
            coverEditFormActions $editWrapper
            toggleEditorBlocker $editWrapper, false
            event_provider.trigger "vitrageedit", [ $editWrapper ]
          # error: null
        return
      return
    # init edit control for all exists
    initEditControl $(".vtrg-edit-wrapper")

    # --- # --- DESTROY --- # --- #
    initDestroyControl = (wrappers) ->
      wrappers.find(".vtrg-edit-control a[rel=destroy]").click (evnt) ->
        evnt.preventDefault()
        $editWrapper = $(@).closest(".vtrg-edit-wrapper")
        if confirm("Are you sure?")
          toggleEditorBlocker $editWrapper, true
          $.ajax
            url: "/vitrage/pieces/" + $editWrapper.data("id")
            type: "DELETE"
            dataType: "html"
            success: (data, textStatus, jqXHR) ->
              $editWrapper.remove()
              event_provider.trigger "vitragedestroyed"
            # error: null
        return
      return
    # init destroy control for all exists
    initDestroyControl $(".vtrg-edit-wrapper")

    # --- # --- CREATE and cancel creating --- # --- #
    coverNewFormActions = ($editWrapper) ->
      # cover Submit action
      $blockForm = $editWrapper.find('form')

      $blockForm.on "ajax:before", ->
        toggleEditorBlocker $editWrapper, true
        return true # do your work buddy

      $blockForm.on "ajax:success", (evnt, data, textStatus, jqXHR) ->
        clwr = $(@).closest(".vtrg-edit-wrapper")
        if $(@).data('remotipartSubmitted')
          a = 12
          console.log "ololo"
        else
          clwr.after data
        brandNewWrapper = clwr.next()
        clwr.remove()
        initDestroyControl brandNewWrapper
        initEditControl brandNewWrapper
        event_provider.trigger "vitragecreated"
      # $blockForm.on "ajax:error"
      $blockForm.on "ajax:complete", ->
        toggleEditorBlocker $(@).closest(".vtrg-edit-wrapper"), false

      # cover Cancel action
      $editWrapper.find('form .actions a').click (evnt) ->
        $clickedAnchor = $(@)
        clickedAnchorParentID = $clickedAnchor.parent().attr("id")
        if clickedAnchorParentID && clickedAnchorParentID.substr(clickedAnchorParentID.length - 13) == "cancel_action"
          evnt.preventDefault()
          $clickedAnchor.closest(".vtrg-edit-wrapper").remove()
          return false

    # --- # --- NEW --- # --- #
    $createAnchors = $(".vtrg-new-block-kinds a")
    $createAnchors.on "ajax:success", (evnt, data, textStatus, jqXHR) ->
      $(".vtrg-add-new-wrapper").before data
      coverNewFormActions $(".vtrg-edit-wrapper:last")
      event_provider.trigger "vitragenew"
    # $createAnchors.on "ajax:error"
    # $createAnchors.on "ajax:complete"
