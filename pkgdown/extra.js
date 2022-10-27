const gsmLifecycleImage = document.createElement("img");
gsmLifecycleImage.setAttribute(
  "src",
  "https://raw.githubusercontent.com/r-lib/lifecycle/main/vignettes/figures/lifecycle-experimental.svg"
);

const addToFooter = function () {
  const aTagElements = document.querySelectorAll("a");
  const aTagArray = Array.from(aTagElements);
  const gsmExperimentalList = [
    "RunStratifiedWorkflow()",
    "Study_Report()",
    "Study_Table()",
    "Study_AssessmentReport()",
    "RunQTL()",
    "SaveQTL()"
  ];
  aTagArray.map((data) => {
    if (gsmExperimentalList.includes(data.textContent)) {
      data.prepend(gsmLifecycleImage.cloneNode(true));
    }
  });
};

window.onload = (event) => {
  addToFooter();
};
