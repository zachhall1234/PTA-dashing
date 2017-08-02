class Dashing.Clock2 extends Dashing.Widget

  ready: ->
    setInterval(@startTime, 500)

  startTime: =>
    today = new Date()
    
    months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    days = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]

    h = today.getHours()
    m = today.getMinutes()
    s = today.getSeconds()
    m = @formatTime(m)
    s = @formatTime(s)
    
    dow = days[today.getDay()]
    month = months[today.getMonth()]
    
    date = dow + " " + @formatTime(today.getDate()) + " " + month + " " + today.getFullYear()
    
    @set('datetime', date + " | " + h + ":" + m + ":" + s)
    
  formatTime: (i) ->
    if i < 10 then "0" + i else i
