class Dashing.Error404list extends Dashing.Widget

  ready: ->


  onData: (data) ->
    # Handle incoming data
    # You can access the html node of this widget with `@node`
    # Example: $(@node).fadeOut().fadeIn() will make the node flash each time data comes in.
    for ec in data.error404list
      ec.count = ec.doc_count
      ec.message = ec.key