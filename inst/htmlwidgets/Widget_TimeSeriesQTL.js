HTMLWidgets.widget({

  name: 'Widget_TimeSeriesQTL',

  type: 'output',

  factory: function(el, width, height) {

    // TODO: define shared variables for this instance

    return {

      renderValue: function(x) {

        results = HTMLWidgets.dataframeToD3(x.results)
        workflow = HTMLWidgets.dataframeToD3(x.workflow)[0]
        workflow.selectedGroupIDs = x.selectedGroupIDs
        workflow.y = 'metric';
        parameters = HTMLWidgets.dataframeToD3(x.parameters)
        analysis = HTMLWidgets.dataframeToD3(x.parameters)

        console.log(analysis)

        const instance = rbmViz.default.timeSeries(
            el,
            results,
            workflow,
            parameters,
            analysis
        );


      },

      resize: function(width, height) {

        // TODO: code to re-render the widget with a new size

      }

    };
  }
});
