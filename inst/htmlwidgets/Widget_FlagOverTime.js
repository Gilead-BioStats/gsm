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
        el.insertAdjacentHTML('beforeend', x.html);

        addGroupSubsetLongitudinalListener(el);
      },

      resize: function(width, height) {
      }
    };
  }
});
