HTMLWidgets.widget({
  name: 'Widget_TimeSeriesQTL',
  type: 'output',
  factory: function(el, width, height) {
    return {
      renderValue: function(x) {
        const results = HTMLWidgets.dataframeToD3(x.results);
        const workflow = HTMLWidgets.dataframeToD3(x.workflow)[0];
        workflow.selectedGroupIDs = x.selectedGroupIDs
        workflow.y = 'metric';
        const parameters = HTMLWidgets.dataframeToD3(x.parameters)
        const analysis = HTMLWidgets.dataframeToD3(x.analysis)

        const instance = rbmViz.default.timeSeries(
          el,
          results,
          workflow,
          parameters,
          analysis
        );
      },
      resize: function(width, height) {
      }
    };
  }
});
