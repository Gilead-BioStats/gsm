HTMLWidgets.widget({
  name: 'Widget_TimeSeriesQTL',
  type: 'output',
  factory: function(el, width, height) {
    return {
      renderValue: function(x) {
        const results = x.results;
        results.groupid = "tmp"
        const workflow = x.workflow;
        workflow.selectedGroupIDs = x.selectedGroupIDs;
        workflow.y = 'metric';
        const parameters = x.parameters;
        const analysis = x.analysis;

        console.log('el: ', el);
        console.log('results: ', results);
        console.log('workflow: ', workflow);
        console.log('parameters: ', parameters);
        console.log('analysis: ', analysis);

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
