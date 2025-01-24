HTMLWidgets.widget({
  name: 'Widget_FlagOverTime',
  type: 'output',
  factory: function(el, width, height) {
    el.innerHTML = '';
    // Apply styles to make the content scrollable if it gets too long
    el.style.overflowY = 'auto';  // Enable vertical scrolling
    el.style.overflowX = 'hidden';  // Prevent horizontal scrolling
    el.style.maxHeight = '400px'; // Set the max height for the widget
    el.style.width = '100%';        // Set width to 100% to prevent overflow

    return {
      renderValue: function(x) {
        // Add group subset dropdown.
        addGroupSubsetLongitudinal(el, x.bExcludeEver);

        // Create container div for the flag over time content
        const contentDiv = document.createElement('div');
        contentDiv.classList.add('flag-over-time-content');
        contentDiv.innerHTML = x.gtFlagOverTime;
        el.appendChild(contentDiv);

        // Insert footnote if provided
        if (x.strFootnote) {
          const footnote = document.createElement('div');
          footnote.style.fontSize = '14px';
          footnote.style.color = '#555';
          footnote.innerHTML = x.strFootnote;
          el.insertBefore(footnote, el.firstChild);
        }

        addGroupSubsetLongitudinalListener(el); // Initial call for filtering
      },

      resize: function(width, height) {
        // Resize function can be implemented if needed
      }
    };
  }
});
