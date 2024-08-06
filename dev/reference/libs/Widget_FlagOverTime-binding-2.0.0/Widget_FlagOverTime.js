HTMLWidgets.widget({
  name: 'Widget_FlagOverTime',
  type: 'output',
  factory: function(el, width, height) {
    el.innerHTML = '';
    // Add group subset dropdown.
    addGroupSubsetLongitudinal(el);

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
