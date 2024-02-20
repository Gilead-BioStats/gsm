const main = window.location.href;

function onCovariateChange(value) {
  const dropdowns = [...document.querySelectorAll('.kri-dropdown')];
  let matchingIds = [];

  dropdowns.forEach(el => {
    if (typeof value !== 'undefined') {
      el.value = value;
    } else {
      el.value = el.options[0].value;
    }

    let elements = document.querySelectorAll(`[id^="${el.value}-"]`);
    elements.forEach(element => {
      matchingIds.push(element.className);
    });
  });

  if (typeof matchingIds !== 'undefined' && matchingIds.length > 0) {
    console.log('selected metric: ', matchingIds);
    window.location.href = `${main}#${matchingIds[0]}`;
  }
}

document.addEventListener("DOMContentLoaded", function () {
  onCovariateChange();
});
