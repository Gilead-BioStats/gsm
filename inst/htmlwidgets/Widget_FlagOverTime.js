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
        toggleButton.textContent = 'Toggle Year View';
        toggleButton.style.marginBottom = '10px';

        // Append the button to the widget container
        el.appendChild(toggleButton);

        // Create container div for the flag over time content
        const contentDiv = document.createElement('div');
        contentDiv.classList.add('flag-over-time-content');
        el.appendChild(contentDiv);

        // Function to update the displayed table
        const updateTable = (showRecent) => {
          contentDiv.innerHTML = showRecent ? x.html_recent12 : x.html_full;
          // Reapply the group subset filtering each time the table is updated
          addGroupSubsetLongitudinalListener(el);
        };

        // Set the default view to recent (12-month) table view
        let showRecent = true;
        updateTable(showRecent);

        // Insert footnote if provided
        if (x.strFootnote) {
          const footnote = document.createElement('div');
          footnote.style.fontSize = '14px';
          footnote.style.color = '#555';
          footnote.innerHTML = x.strFootnote;
          el.insertBefore(footnote, el.firstChild);
        }

        // Toggle button to switch between recent (12-month) and full view
        toggleButton.addEventListener('click', () => {
          showRecent = !showRecent;
          updateTable(showRecent);
        });

        addGroupSubsetLongitudinalListener(el); // Initial call for filtering
      },

      resize: function(width, height) {
        // Resize function can be implemented if needed
      }
    };
  }
});
