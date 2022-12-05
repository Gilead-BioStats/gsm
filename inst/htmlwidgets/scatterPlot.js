HTMLWidgets.widget({

  name: 'scatterPlot',

  type: 'output',

  factory: function(el, width, height) {

    return {

      renderValue: function(x) {

      let results = HTMLWidgets.dataframeToD3(x.results)

      let workflow = HTMLWidgets.dataframeToD3(x.workflow)[0]
      workflow.selectedGroupIDs = number_to_array(x.selectedGroupIDs)
          console.log(workflow);

      let bounds = HTMLWidgets.dataframeToD3(x.bounds)

      const instance = rbmViz.default.scatterPlot(
           el,
           results,
           workflow,
           bounds
         )

      },

      resize: function(width, height) {

        // TODO: code to re-render the widget with a new size

      }

    };
  }
});
