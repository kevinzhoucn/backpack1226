$(document).ready( function() {        
  // create the chart
  var frist_query_ready = false;
  var data_ready = false;
  var chart = new Highcharts.StockChart({            
    chart: {
      renderTo: 'chart_full_area'
    },
    title: {
        text: ''
    },

    subtitle: {
        text: ''
    },

    xAxis: {
        dateTimeLabelFormats: {
            second: '%H:%M:%S',
            day: '%e. %b'
        }
    },

    rangeSelector : {
        buttons : [{
            type : 'hour',
            count : 1,
            text : '1h'
        }, {
            type : 'day',
            count : 1,
            text : '1D'
        }, {
            type : 'all',
            count : 1,
            text : 'All'
        }],
        selected : 2,
        inputEnabled : false
    },

    series : [{
        data : <%= @datapoints %>,
        // gapSize: 5,
        type: "line",
        tooltip: {
            valueDecimals: 2
        }
    }]
  });
});