HTMLWidgets.widget({
  name: 'Widget_TimeSeriesQTL',
  type: 'output',
  factory: function(el, width, height) {
    return {
      renderValue: function(x) {

        const workflow = x.workflow[0];
        workflow.selectedGroupIDs = x.selectedGroupIDs
        workflow.y = 'metric';

        const instance = rbmViz.default.timeSeries(
          el,
          x.results,
          workflow,
          x.parameters,
          x.analysis
        );

      },
      resize: function(width, height) {
      }
    };
  }
});
