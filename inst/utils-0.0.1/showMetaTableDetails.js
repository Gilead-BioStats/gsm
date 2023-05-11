let detailButton = document.querySelector('.btn-show-details')
let hidden = false;

detailButton.addEventListener('click', function() {

    console.log('click')

    let shownTable = document.querySelector('#study_table');
    let hiddenTable = document.querySelector('#study_table_hide');

    if (!hidden) {
      shownTable.style.display = 'none';
      hiddenTable.style.display = 'block';
      hidden = true;
    } else {
      shownTable.style.display = 'block';
      hiddenTable.style.display = 'none';
      hidden = false;
    }

})
