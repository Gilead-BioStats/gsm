HTMLWidgets.widget({

  name: 'barChart',

  type: 'output',

  factory: function(el, width, height) {

    return {

      renderValue: function(x) {

      let results = HTMLWidgets.dataframeToD3(x.results)

      let workflow = HTMLWidgets.dataframeToD3(x.workflow)[0]
      workflow.y = x.yaxis
      workflow.selectedGroupIDs = number_to_array(x.selectedGroupIDs)
          console.log(workflow);

      let threshold = HTMLWidgets.dataframeToD3(x.threshold)

      const instance = rbmViz.default.barChart(
           el,
           results,
           workflow,
           threshold
         )

      },

      resize: function(width, height) {

        // TODO: code to re-render the widget with a new size

      }

    };
  }
});
