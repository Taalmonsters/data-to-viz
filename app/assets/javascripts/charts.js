var Charts = {
	doDebug: true,
	
	debug: function(msg) {
		console.log(msg);
	},
	
	displayBar: function(id, json, w, h) {
		Highcharts.setOptions({
		    colors: (function () {
    	        var colors = [],
	            base = json['color'],
	            i;

		        for (i = 0; i < json['data'].length; i += 1) {
		            // Start out with a darkened base color (negative brighten), and end
		            // up with a much brighter color
		            colors.push(Highcharts.Color(base).brighten((i - 2) / 10).get());
		        }
		        return colors;
		    }())
		});
		$(id).html("");
		$(id).highcharts({
	        chart: {
	            plotBackgroundColor: null,
	            plotBorderWidth: null,
	            plotShadow: false,
	            type: 'column',
	            width: w,
	            height: h
	        },

	        plotOptions: {
	            column: {
	                colorByPoint: true
	            }
	        },
	        
	        title: {
                text: json['title']
            },
            legend: {
                enabled: false
            },
            
            xAxis: {
                type: 'category',
                title: {
                	text: json['x-axis']
                }
            },
            
            yAxis: json['y-axis'],
            
            tooltip: {
                valueSuffix: json['y-unit']
            },

            series: [{
            	'name': '',
            	'data': json['data']
            }]
			
		});
	},
	
	displayLine: function(id, json, w, h) {
		Highcharts.setOptions({
		    colors: (function () {
    	        var colors = [],
	            base = json['color'],
	            i;

		        for (i = 0; i < json['series'].length; i += 1) {
		            // Start out with a darkened base color (negative brighten), and end
		            // up with a much brighter color
		            colors.push(Highcharts.Color(base).brighten(i / 5).get());
		        }
		        return colors;
		    }())
		});
		$(id).html("");
		$(id).highcharts({
	        chart: {
	            plotBackgroundColor: null,
	            plotBorderWidth: null,
	            plotShadow: false,
	            type: 'line',
	            width: w,
	            height: h
	        },
            
            xAxis: json['x-axis'],
            
            yAxis: json['y-axis'],
            
            tooltip: {
                valueSuffix: json['y-unit']
            },

            series: json['series']
			
		});
	},
	
	displayPie: function(id, json, w) {
		Highcharts.getOptions().plotOptions.pie.colors = (function () {
	        var colors = [],
	            base = json['color'],
	            i;

	        for (i = 0; i < json['data'].length; i += 1) {
	            // Start out with a darkened base color (negative brighten), and end
	            // up with a much brighter color
	            colors.push(Highcharts.Color(base).brighten((i - 2) / 13).get());
	        }
	        return colors;
	    }());
		
		$(id).html("");
		$(id).highcharts({
	        chart: {
	            plotBackgroundColor: null,
	            plotBorderWidth: null,
	            plotShadow: false,
	            type: 'pie',
	            width: w,
	            height: w
	        },
	        
	        title: {
                text: json['title']
            },

            tooltip: {
                pointFormat: '<b>{point.y:,.0f} '+json['unit']+' ({point.percentage:.1f}%)</b>'
            },

            plotOptions: {
                pie: {
                    allowPointSelect: true,
                    cursor: 'pointer',
                    dataLabels: {
                        enabled: true,
                        format: '<b>{point.name}</b>: {point.percentage:.1f} %',
                        style: {
                            color: (Highcharts.theme && Highcharts.theme.contrastTextColor) || 'black'
                        }
                    }
                }
            },

            series: [{
            	name: '',
            	data: json['data']
            }]
			
		});
	},
	
	displayZipf: function(id, json, w, h) {
		Highcharts.setOptions({
		    colors: (function () {
    	        var colors = [],
	            base = json['color'],
	            i;

		        for (i = 0; i < json['series'].length; i += 1) {
		            // Start out with a darkened base color (negative brighten), and end
		            // up with a much brighter color
		            colors.push(Highcharts.Color(base).brighten(i / 5).get());
		        }
		        return colors;
		    }())
		});
		$(id).html("");
		$(id).highcharts({
	        chart: {
	            plotBackgroundColor: null,
	            plotBorderWidth: null,
	            plotShadow: false,
	            type: 'scatter',
	            width: w,
	            height: h
	        },
	        
	        title: {
                text: json['title']
            },
            
            xAxis: json['x-axis'],
            
            yAxis: json['y-axis'],

            series: json['series']
			
		});
	},
	
	init: function() {
		if ($('#bar_color').length > 0)
			$('#bar_color').minicolors({theme: 'bootstrap'});
		if ($('#line_color').length > 0)
			$('#line_color').minicolors({theme: 'bootstrap'});
		if ($('#pie_color').length > 0)
			$('#pie_color').minicolors({theme: 'bootstrap'});
		if ($('#zipf_color').length > 0)
			$('#zipf_color').minicolors({theme: 'bootstrap'});
	}
};

$(document).on('click', '.btn-submit', function(e) {
	$('.chart-display').html("Loading...");
});
