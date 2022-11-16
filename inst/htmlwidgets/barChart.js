HTMLWidgets.widget({

  name: 'barChart',

  type: 'output',

  factory: function(el, width, height) {

    return {

      renderValue: function(x) {

      let data = HTMLWidgets.dataframeToD3(x.data)

      let config = HTMLWidgets.dataframeToD3(x.config)[0]
      config.y = x.yaxis
      config.selectedGroupIDs = number_to_array(x.selectedGroupIDs)
          console.log(config);

      let threshold = HTMLWidgets.dataframeToD3(x.threshold)

      const instance = rbmViz.default.barChart(
           el,
           data,
           config,
           threshold
         )

      },

      resize: function(width, height) {

        // TODO: code to re-render the widget with a new size

      }

    };
  }
});
