document.addEventListener("load", function() {
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
