HTMLWidgets.widget({

  name: 'Widget_TimeSeries',

  type: 'output',

  factory: function(el, width, height) {

    // TODO: define shared variables for this instance

    return {

      renderValue: function(x) {

        results = HTMLWidgets.dataframeToD3(x.results)
        workflow = HTMLWidgets.dataframeToD3(x.workflow)[0]
        workflow.selectedGroupIDs = x.selectedGroupIDs
        parameters = HTMLWidgets.dataframeToD3(x.parameters)

        const instance = rbmViz.default.timeSeries(
            el,
            results,
            workflow,
            parameters
        );

        el.previousElementSibling.addEventListener('change', (event) => {
          instance.helpers.updateSelectedGroupIDs(event.target.value);
        });


      },

      resize: function(width, height) {

        // TODO: code to re-render the widget with a new size

      }

    };
  }
});
