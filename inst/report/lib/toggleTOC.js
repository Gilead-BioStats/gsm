document.addEventListener("DOMContentLoaded", function () {
  console.log("Document loaded. Initializing TOC toggle functionality.");

  // Create the toggle button
  const button = document.createElement("button");
  button.id = "toc-toggle";
  button.style.position = "fixed";
  button.style.top = "10px";
  button.style.left = "10px";
  button.style.zIndex = "1000";
  button.style.width = "80px";
  button.style.height = "25px";
  button.style.display = "flex";
  button.style.flexDirection = "column";
  button.style.justifyContent = "space-around";
  button.style.alignItems = "center";
  button.style.backgroundColor = "transparent";
  button.style.color = '#9D9D9D';
  button.style.border = "none";
  button.style.cursor = "pointer";
  button.style.borderRadius = "10px";
  button.innerHTML = 'Hide TOC';

  // Create the hamburger lines
  // for (let i = 0; i < 3; i++) {
  //   const line = document.createElement("div");
  //   line.style.width = "100%";
  //   line.style.height = "4px";
  //   line.style.backgroundColor = "gray";
  //   line.style.borderRadius = "2px";
  //   button.appendChild(line);
  // }

  document.body.appendChild(button);
  console.log("TOC toggle button created and added to the page.");

  // Select the TOC and main content elements
  const toc = document.querySelector("#TOC");
  const mainContent = document.querySelector(".col-xs-12.col-sm-8.col-md-9");

  // Add click event to toggle TOC visibility and adjust content width
  button.addEventListener("click", function () {
    console.log("Toggle button clicked.");
    toc.classList.toggle("hidden");

    if (toc.classList.contains("hidden")) {
      console.log("TOC is now hidden. Expanding main content.");
      mainContent.classList.remove("col-sm-8", "col-md-9");
      mainContent.classList.add("col-sm-12", "col-md-12");
      button.innerHTML = 'Show TOC';
      button.style.backgroundColor = '#9D9D9D';
      button.style.color = 'white';
    } else {
      console.log("TOC is now visible. Restoring main content width.");
      mainContent.classList.remove("col-sm-12", "col-md-12");
      mainContent.classList.add("col-sm-8", "col-md-9");
      button.innerHTML = 'Hide TOC';
      button.style.backgroundColor = 'transparent';
      button.style.color = '#9D9D9D';
    }
  });

  // Add CSS for the 'hidden' class dynamically
  const style = document.createElement("style");
  style.innerHTML = `
    #TOC.hidden {
      display: none;
    }
  `;
  document.head.appendChild(style);
});document.addEventListener("load", function() {
  console.log("JavaScript is loaded and running!");
  // Create the toggle button
  const button = document.createElement("button");
  button.id = "toc-toggle";
  button.textContent = "Toggle TOC";
  document.body.appendChild(button);

  // Get the TOC element
  const toc = document.querySelector("#TOC");

  // Add event listener to toggle button
  button.addEventListener("click", function() {
    if (toc.classList.contains("hidden")) {
      toc.classList.remove("hidden");
    } else {
      toc.classList.add("hidden");
    }
  });
});
