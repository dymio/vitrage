$(document).ready ->
  if $(".vtrg-add-new-wrapper").length

    # # # SORTABLE module # TODO find correct place for this module
    sortableo = null
    sortable_el = document.getElementById('vitrage-edit')

    initSortable = ->
      if sortableo
        sortableo.destroy()
        sortableo = null
      sortableo = Sortable.create document.getElementById('vitrage-edit'),
        sort: true
        handle: ".vtrg-edit-control-move"
        onUpdate: (evnt) ->
          draggedItem = $(evnt.item)
          nextItem = draggedItem.next()
          # console.log "Next item has id = " + nextItem.data("id")
          $.ajax
            url: "/vitrage/pieces/" + draggedItem.data("id") + "/reorder"
            type: "POST"
            dataType: "json"
            data:
              beforeid: if nextItem.length then nextItem.data("id") else "end"
            # success: (data, textStatus, jqXHR) ->
            # error: null # TODO

    initSortable()
    # # # END OF SORTABLE module

    event_provider = $(".vtrg-add-new-wrapper")

    toggleEditorBlocker = ($editWrapper, act) ->
      $editWrapper.toggleClass 'blocked', act

    showPieceInputsErrors = ($editWrapper, responseText) ->
      $editWrapper.find("li.input.error").removeClass("error")

      data = null
      try
        data = JSON.parse(responseText)
      catch error
        a = 12 # at least we tried
      return true unless data

      if data.piece && data.errors
        for key, val of data.errors
          $errorIWrapper = $editWrapper.find "li.input#vitrage_pieces_" + data.piece.toString() + "_" + key.toString() + "_input"
          $errorIWrapper.addClass "error"

    # --- # --- SHOW --- # --- #
    restoreShowState = ($editWrapper, viewdata) ->
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
            restoreShowState $editWrapper, data
          # error: null # TODO

    # --- # --- UPDATE and cancel editing --- # --- #
    coverEditFormActions = ($editWrapper) ->
      # cover Submit action
      $blockForm = $editWrapper.find('form')

      $blockForm.on "ajax:before", ->
        toggleEditorBlocker $editWrapper, true
        return true # do your work buddy

      $blockForm.on "ajax:success", (evnt, data, textStatus, jqXHR) ->
        event_provider.trigger "vitrageupdated"
        restoreShowState $(@).closest(".vtrg-edit-wrapper")

      $blockForm.on "ajax:error", (evnt, xhr, status, error) ->
        showPieceInputsErrors $(@).closest(".vtrg-edit-wrapper"), xhr.responseText

      $blockForm.on "ajax:complete", (evnt, para1, para2) ->
        toggleEditorBlocker $(@).closest(".vtrg-edit-wrapper"), false


      # cover Cancel action
      $editWrapper.find('form .actions a').click (evnt) ->
        $clickedAnchor = $(@)
        clickedAnchorParentID = $clickedAnchor.parent().attr("id")
        if clickedAnchorParentID && clickedAnchorParentID.substr(clickedAnchorParentID.length - 13) == "cancel_action"
          evnt.preventDefault()
          toggleEditorBlocker $editWrapper, true
          restoreShowState $editWrapper
          return false

    # --- # --- EDIT --- # --- #
    initEditControl = (wrappers) ->
      wrappers.find(".vtrg-edit-control a[rel=edit]").click (evnt) ->
        evnt.preventDefault()
        $editWrapper = $(@).closest(".vtrg-edit-wrapper")
        toggleEditorBlocker $editWrapper, true
        $.ajax
          url: "/vitrage/pieces/" + $editWrapper.data("id") + "/edit"
          dataType: "html"
          success: (data, textStatus, jqXHR) ->
            $editWrapper.addClass "editmode"
            $editWrapper.children(".vtrg-edit-body").html data
            coverEditFormActions $editWrapper
            toggleEditorBlocker $editWrapper, false
            event_provider.trigger "vitrageedit", [ $editWrapper ]
          # error: null # TODO
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
            # error: null # TODO
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
        $editWrapper = $(@).closest(".vtrg-edit-wrapper")
        $editWrapper.attr 'data-id', data
        initDestroyControl $editWrapper
        initEditControl $editWrapper
        event_provider.trigger "vitragecreated", [ $editWrapper ]
        restoreShowState $editWrapper
        initSortable()

      $blockForm.on "ajax:error", (evnt, xhr, status, error) ->
        showPieceInputsErrors $(@).closest(".vtrg-edit-wrapper"), xhr.responseText

      $blockForm.on "ajax:complete", (evnt, para1, para2) ->
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
      # $(".vtrg-add-new-wrapper").before data
      $("#vitrage-edit").append data
      $editWrapper = $(".vtrg-edit-wrapper:last")
      coverNewFormActions $editWrapper
      event_provider.trigger "vitragenew", [ $editWrapper ]

    # $createAnchors.on "ajax:error" # TODO
    # $createAnchors.on "ajax:complete" # TODO
