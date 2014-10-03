var data;
// var parseDate = d3.time.format("%Y-%m-%d %I:%M:%S").parse;
var parseDate = d3.time.format("%Y-%m-%d").parse;
 d3.json("/api/articles",function(json){
  console.warn(json);
  jQuery.each(json, function(j, val2 ) {
    val2.values.map(function(d) {
        d.x = parseDate(String(d.x));
    });
  });

  nv.addGraph(function() {
      var chart = nv.models.lineChart()
           .margin({right:35})
           .useInteractiveGuideline(true);
           
      chart.xAxis
//        .axisLabel('Time (ms)')
        .scale(d3.time.scale())
        .tickFormat(function(d) { 
          return d3.time.format("%Y-%m-%d")(new Date(d)); });

      chart.yAxis
        .axisLabel('Voltage (v)')
        .tickFormat(d3.format('.02f'))
        ;

      d3.select('#main')
        .datum(json)
        .transition().duration(500)
        .call(chart)
        ;

      nv.utils.windowResize(chart.update);

      return chart;
    });
  });