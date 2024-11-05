HTMLWidgets.widget({
  name: 'Widget_FlagOverTime',
  type: 'output',
  factory: function(el, width, height) {
    el.innerHTML = '';
    // Add group subset dropdown.
    addGroupSubsetLongitudinal(el);

    // Apply styles to make the content scrollable if it gets too long
    el.style.overflowY = 'auto';  // Enable vertical scrolling
    el.style.overflowX = 'hidden';  // Prevent horizontal scrolling
    el.style.maxHeight = '400px'; // Set the max height for the widget
    el.style.width = '100%';        // Set width to 100% to prevent overflow

    return {
      renderValue: function(x) {
        // Create the toggle button
        const toggleButton = document.createElement('button');
        toggleButton.textContent = 'Toggle Year/All Snapshot View';
        toggleButton.style.marginBottom = '10px';

        // Append the button to the widget container
        el.appendChild(toggleButton);

        // Function to update the displayed table
        const updateTable = (showRecent) => {
          el.querySelector('.flag-over-time-content').innerHTML = showRecent ? x.html_recent12 : x.html_full;
        };

        // Add initial table and button listener
        const contentDiv = document.createElement('div');
        contentDiv.classList.add('flag-over-time-content');
        el.appendChild(contentDiv);

        // Insert the flag overtime table content with default view set to recent (12-month) view.
        let showRecent = true;
        updateTable(showRecent);

        // Check if the footnote is not NULL or undefined
        if (x.strFootnote) {
          // Create a div for the footnote.
          const footnote = document.createElement('div');
          footnote.style.fontSize = '14px'; // Set a smaller font size for the footnote.
          footnote.style.color = '#555'; // Use a lighter color for the footnote text.

          // Set the content of the footnote from the input.
          footnote.innerHTML = x.strFootnote;

          // Insert the footnote div at the top of the element (before flag overtime table).
          el.insertBefore(footnote, el.firstChild);
        }

        // Toggle button click event to switch between recent (12-month) and full view.
        toggleButton.addEventListener('click', () => {
          showRecent = !showRecent;
          updateTable(showRecent);
        });

        addGroupSubsetLongitudinalListener(el);
      },

      resize: function(width, height) {
        // Resize function can be implemented if needed
      }
    };
  }
});
