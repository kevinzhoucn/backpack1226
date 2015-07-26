$("#chart_test_button").click ->
  DynamicChart()

DynamicChart = (test) ->
  seq_num = $("#last_seq").text();
  url = "/apiv00/front/test_data?seq=" + seq_num
  data = []
  $.ajax
    type: 'GET'
    url: url
    data: data
    success: (result) ->
      t_data = result
    error: (result) ->
      alert("Error")

DrawChart = ->
  chart_area = new Highcharts.Chart
    chart: type: 'line', renderTo: 'chart_test_container'
    title: text: '', x: -20
    subtitle: text: '', x: -20
    xAxis: tickmarkPlacement: 'on', \ 
           categories: ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10']
    yAxis: min: 0, \
           title: { text: '数值' }, \
           plotLines: [ value: 0, width: 1, color: '#808080' ]
    tooltip: valueSuffix: ''
    legend: layout: 'vertical', \
            align: 'right', \
            verticalAlign: 'middle', \
            borderWidth: 0
    series: [ name: '通道1', data: DynamicChart() ]

test_01 = ->
  console.log("this is test 01!")

$ ->
  if $("#chart_test_container").length > 0 
    DrawChart