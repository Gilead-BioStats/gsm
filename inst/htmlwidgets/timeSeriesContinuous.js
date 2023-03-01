HTMLWidgets.widget({

  name: 'timeSeriesContinuous',

  type: 'output',

  factory: function(el, width, height) {

    // TODO: define shared variables for this instance

    return {

      renderValue: function(x) {

        results = HTMLWidgets.dataframeToD3(x.results)
        workflow = HTMLWidgets.dataframeToD3(x.workflow)[0]
        parameters = HTMLWidgets.dataframeToD3(x.parameters)

        // visualization
        const instance = rbmViz.default.timeSeries(
            el,
            results,
            workflow,
            parameters
        );


      },

      resize: function(width, height) {

        // TODO: code to re-render the widget with a new size

      }

    };
  }
});
