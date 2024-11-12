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
        const toggleContainer = document.createElement('div');
        // Create the label for the checkbox
        const label = document.createElement('label');
        label.classList.add('toggle');
        toggleContainer.appendChild(label);

        const checkbox = document.createElement('input');
        checkbox.type = 'checkbox';
        checkbox.classList.add('toggle-checkbox')
        checkbox.id = 'toggle-checkbox';
        checkbox.checked = false;
        toggleContainer.appendChild(checkbox);

        // Create the switch element
        const switchElement = document.createElement('div');
        switchElement.classList.add('toggle-switch');
        switchElement.id = "toggle-switch"
        toggleContainer.appendChild(switchElement);

        const labelText = document.createElement('span');
        labelText.classList.add("toggle-label");
        labelText.textContent = "Show All Time";
        toggleContainer.appendChild(labelText);


        // Append the button to the widget container
        el.appendChild(toggleContainer);

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
        toggleContainer.addEventListener('click', () => {
          showRecent = !showRecent;
          updateTable(showRecent);
          checkbox.checked = !showRecent;
          if (!showRecent) {
            labelText.textContent = 'Show Recent';
        } else {
            labelText.textContent = 'Show All Time';
        }
        });

        addGroupSubsetLongitudinalListener(el); // Initial call for filtering
      },

      resize: function(width, height) {
        // Resize function can be implemented if needed
      }
    };
  }
});
