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
    series: [ name: '通道1', data: [0] ]

DynamicChart = (chart_area) ->
  seq_num = $("#last_seq").text();
  url = "/apiv00/front/test_data?seq=" + seq_num
  data = []
  series_data = chart_area.series[0]
  $.ajax
    type: 'GET'
    url: url
    data: data
    success: (result) ->
      t_data = result
      console.log(t_data[1])
      series_data.addPoint point for point in t_data[1]
      return t_data[1]
    error: (result) ->
      alert("Error")

# AddSeriesPoints = (series, data_array) -> 


test_01 = ->
  console.log("this is test 02!")

$ ->
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
    series: [ name: '通道1', data: [0] ]

  data_list = chart_area.series[0]
  data_list.addPoint(3)

#  DynamicChart(chart_area)

  setInterval(DynamicChart, 5000, chart_area);
    
  $("#chart_test_button").click ->
    DynamicChart(chart_area)

