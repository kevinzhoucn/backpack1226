# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


toggleItem = (elem) ->
  data = "data[device_id]=" + $.now()
  url = "/v1.0/devices"
  $.ajax
    type: 'POST'
    url: url
    data: data
$ ->
  $("#test_button").on 'click', (e) -> toggleItem e.target

  #if $("#chart_area").length > 0
  #  $.getScript("/js/chart/drawChart.js")
  #if false
  #  $.getScript("/js/libs/charts/highstock.js", \ 
  #    (-> $.getScript("/js/chart/drawChart.js") ) )