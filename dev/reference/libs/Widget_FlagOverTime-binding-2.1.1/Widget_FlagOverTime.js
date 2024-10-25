HTMLWidgets.widget({
  name: 'Widget_FlagOverTime',
  type: 'output',
  factory: function(el, width, height) {
    el.innerHTML = '';
    // Add group subset dropdown.
    addGroupSubsetLongitudinal(el);

    // Apply styles to make the content scrollable if it gets too long
    el.style.overflowY = 'auto';  // Enable vertical scrolling
    el.style.maxHeight = '400px'; // Set the max height for the widget

    return {
      renderValue: function(x) {
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

        // Insert the flag overtime table content.
        el.insertAdjacentHTML('beforeend', x.html);

        addGroupSubsetLongitudinalListener(el);
      },

      resize: function(width, height) {
      }
    };
  }
});
