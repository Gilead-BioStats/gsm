HTMLWidgets.widget({

  name: 'Widget_TimeSeriesQTL',

  type: 'output',

  factory: function(el, width, height) {

    // TODO: define shared variables for this instance

    return {

      renderValue: function(x) {


        const mergeParameters = function (defaultParameters, customParameters) {
    const dates = [
        ...new Set(
            customParameters.map((parameter) => parameter.gsm_analysis_date)
        ),
    ];

    const parametersOverTime = dates
        .map((date) => {
            const parameters = defaultParameters.map((defaultParameter) => {
                const customParameter = customParameters.find(
                    (customParameter) =>
                        customParameter.gsm_analysis_date === date &&
                        customParameter.workflowid ===
                            defaultParameter.workflowid &&
                        customParameter.index === defaultParameter.index
                );

                const parameter = {
                    ...defaultParameter,
                    ...customParameter,
                };

                parameter.gsm_analysis_date = date;
                parameter.snapshot_date = date;
                parameter.value =
                    customParameter !== undefined
                        ? customParameter.value
                        : defaultParameter.default;
                delete parameter.default;
                delete parameter.configurable;

                return parameter;
            });

            return parameters;
        })
        .flatMap((parameters) => parameters);

    return parametersOverTime;
};

        results = HTMLWidgets.dataframeToD3(x.results)
        workflow = HTMLWidgets.dataframeToD3(x.workflow)[0]
        workflow.selectedGroupIDs = x.selectedGroupIDs
        workflow.y = 'metric';
        parameters = HTMLWidgets.dataframeToD3(x.parameters)
        analysis = HTMLWidgets.dataframeToD3(x.analysis)
        status_param = HTMLWidgets.dataframeToD3(x.status_param)

        const instance = rbmViz.default.timeSeries(
            el,
            results,
            workflow,
            mergeParameters(parameters, status_param).filter(parameter => parameter.snapshot_date === parameters[0].snapshot_date),
            analysis
        );


      },

      resize: function(width, height) {

        // TODO: code to re-render the widget with a new size

      }

    };
  }
});
