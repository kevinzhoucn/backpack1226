$(document).ready( function() {        
    // create the chart
    var frist_query_ready = false;
    var data_ready = false;
    var chart = new Highcharts.StockChart({            
        chart: {
          renderTo: 'chart_area'
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
            // breaks: [{ // Nights
            //     from: Date.UTC(2011, 9, 6, 16),
            //     to: Date.UTC(2011, 9, 7, 8),
            //     repeat: 24 * 36e5
            // }, { // Weekends
            //     from: Date.UTC(2011, 9, 7, 16),
            //     to: Date.UTC(2011, 9, 10, 8),
            //     repeat: 7 * 24 * 36e5
            // }]
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
            data : [],
            // gapSize: 5,
            type: "line",
            tooltip: {
                valueDecimals: 2
            }
        }]
    });

    $.extend({
        DynamicChart : function(chart) {
            var seq_num = $("#last_seq").text();
            var channel_id = $("#channel_id").text();
            var url = "/data/getDatapoints/" + channel_id + "?seq=" + seq_num;
            var series = chart.series[0];

            if (true) {
                $.ajax({
                    type: 'GET',
                    url: url,
                    data: [],
                    success: function(result){
                        var t_seq = result[0];
                        $("#last_seq").text(t_seq);
                        var t_data = result[1];
                        // if ( t_data.length > 4000 ){
                        //     t_data = t_data.splice(0, 2000);
                        // }
                        // var new_series_data = series.getData();
                        console.log(t_data);
                        // var new_series = series.data.concat(t_data);
                        // var new_series_length = new_series_data.length;
                        // if (new_series_length > 4000) {
                        //     new_series = new_series.splice(new_series_length - 2000, new_series_length);
                        // }
                        // $.each(t_data, function(){
                        //     series.addPoint(this);
                        // });
                        // series.setData(new_series);
                        series.setData(t_data);
                        return t_data;
                    },
                    error: function(result){
                      console.log("Error: " + result);
                    }
                });
            }
        }
    }); 

    $.extend({
        FirstDataChart : function(chart, frist_query_ready) {
            var seq_num = $("#last_seq").text();
            var channel_id = $("#channel_id").text();
            var url = "/data/getDatapoints/" + channel_id + "?seq=" + seq_num;
            var series = chart.series[0];

            $.ajax({
                type: 'GET',
                url: url,
                data: [],
                success: function(result){
                    console.log(result)
                    var t_seq = result[0];
                    $("#last_seq").text(t_seq);
                    var t_data = result[1];
                    console.log(t_data)
                    series.setData(t_data);
                    frist_query_ready = true;

                    setInterval($.DynamicChart, 5000, chart);
                    return t_data;
                },
                error: function(result){
                  console.log("Error: " + result);
                }
            });
        }
    }); 

    $.FirstDataChart(chart, frist_query_ready)        
});