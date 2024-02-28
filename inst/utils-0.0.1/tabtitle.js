function tabtitle(){
   var title = document.querySelector("#study-discontinuation-reasons > div.chart-title");
   title.innerText = document.querySelector("#scatter-plot > p > font > strong").innerText;
   document.querySelector("#scatter-plot > p") = document.querySelector("#study-discontinuation-reasons > div.chart-title");
}
