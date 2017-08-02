class Dashing.Jenkins extends Dashing.Widget

  ready: ->


  onData: (data) ->
    # Handle incoming data
    # You can access the html node of this widget with `@node`
    # Example: $(@node).fadeOut().fadeIn() will make the node flash each time data comes in.
    for job in data.passingJobs
      job.description = job.name + ' (#' + job.lastBuild.number + ')'