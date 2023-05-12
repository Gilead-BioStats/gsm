let detailButton = document.querySelector('.btn-show-details')
let hidden = false;

detailButton.addEventListener('click', function() {

    console.log('click')

    let shownTable = document.querySelector('#study_table');
    let hiddenTable = document.querySelector('#study_table_hide');
    let toggleLabel = document.querySelector('.toggle-label')

    if (!hidden) {
      shownTable.style.display = 'none';
      hiddenTable.style.display = 'block';
      toggleLabel.innerHTML = 'Hide Details';
      hidden = true;
    } else {
      shownTable.style.display = 'block';
      hiddenTable.style.display = 'none';
      toggleLabel.innerHTML = 'Show Details';
      hidden = false;
    }

})
