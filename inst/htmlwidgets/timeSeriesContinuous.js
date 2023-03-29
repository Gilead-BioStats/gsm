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


        if (x.analysis !== null) {
          analysis = HTMLWidgets.dataframeToD3(x.analysis)
        } else {
          analysis = null
        }


               // add click event listener to chart
               /*
                if (x.addSiteSelect)
                    workflow.clickCallback = function(d) { // clickCallback.bind(null, instance, siteSelect);
                        instance.data.config.selectedGroupIDs = instance.data.config.selectedGroupIDs.includes(d.groupid)
                            ? 'None'
                            : d.groupid;
                        siteSelect.value = instance.data.config.selectedGroupIDs;
                        instance.helpers.updateConfig(instance, instance.data.config);
                    };
               */

        // visualization
        const instance = rbmViz.default.timeSeries(
            el,
            results,
            workflow,
            parameters,
            analysis
        );

                // add dropdown that highlights sites
                /*
                let siteSelect;
                if (x.addSiteSelect)
                    siteSelect = addSiteSelect(el, results, instance);
                */



      },

      resize: function(width, height) {

        // TODO: code to re-render the widget with a new size

      }

    };
  }
});
