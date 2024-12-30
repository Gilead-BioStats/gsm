/**
 * Adds a dropdown to filter longitudinal table by flags.
 *
 * @param {Node} el - an element in the DOM
 *
 * @returns {Node} HTML select element
 */

 /*
dependencies:
   - name: findMatchingRows
    version: 0.0.1
    src: 'gt-utils-0.0.1'
    script: 'findMatchingRows.js'
  - name: findHeadersWithMatchingSiblings
    version: 0.0.1
    src: 'gt-utils-0.0.1'
    script: 'findHeadersWithMatchingSiblings.js'
  - name: showHideRows
    version: 0.0.1
    src: 'gt-utils-0.0.1'
    script: 'showHideRows.js'
 */

const addGroupSubsetLongitudinal = (el, bExcludeEver) => {
  // add container in which to place dropdown
  const groupSubsetContainer = document.createElement('div');
  el.insertBefore(groupSubsetContainer, el.firstChild);

  // add dropdown label
  const groupSubsetLabel = document.createElement('span');
  groupSubsetLabel.innerHTML = 'Site Subset: ';
  groupSubsetContainer.appendChild(groupSubsetLabel);

  // add dropdown
  const groupSubset = document.createElement('select');
  groupSubsetContainer.appendChild(groupSubset);

  // add options
  let subsets = [
    { value: 'all', text: 'All' },
    { value: 'red/amber', text: '1+ flag (latest)' },
    { value: 'red/amber-ever', text: '1+ flag (ever)' },
    { value: 'red', text: '1+ red flag (latest)' },
    { value: 'red-ever', text: '1+ red flag (ever)' },
    { value: 'amber', text: '1+ amber flag (latest)' },
    { value: 'amber-ever', text: '1+ amber flag (ever)' },
    { value: 'flag-changed', text: 'Flag changed' }
  ];

    // If widget is subset on flags present in most recent snapshot, remove 'ever' options.
    if (bExcludeEver) {
        subsets = subsets.filter(subset => !subset.value.includes('ever'));
    }

  for (const subset of subsets) {
      const option = document.createElement('option');
      option.innerHTML = subset.text;
      option.value = subset.value;
      groupSubset.appendChild(option);
  }
};

const addGroupSubsetLongitudinalListener = (el) => {
  const selector = el.querySelector('select');
  const gtTable = el.querySelector('table.gt_table');

  // Create vars for row contents.
  const rows = gtTable.querySelectorAll('tbody tr');
  const flagRows = findMatchingRows(rows, 'td');
  const amberRowsEver = findMatchingRows(rows, 'svg[style*="fill:#FEAA02"]');
  const amberRowsLatest = findMatchingRows(rows, 'td:last-of-type > svg[style*="fill:#FEAA02"]');
  const redRowsEver = findMatchingRows(rows, 'svg[style*="fill:#FF5859"]');
  const redRowsLatest = findMatchingRows(rows, 'td:last-of-type > svg[style*="fill:#FF5859"]');
  const changeRows = findMatchingRows(rows, 'td[headers$="FlagChange"]:not(:empty)');

  // Find header rows that relate to those vars.
  const headerRows = gtTable.querySelectorAll('tbody tr.gt_group_heading_row');
  const headersWithAmberEver = findHeadersWithMatchingSiblings(headerRows, amberRowsEver);
  const headersWithAmberLatest = findHeadersWithMatchingSiblings(headerRows, amberRowsLatest);
  const headersWithRedEver = findHeadersWithMatchingSiblings(headerRows, redRowsEver);
  const headersWithRedLatest = findHeadersWithMatchingSiblings(headerRows, redRowsLatest);
  const headersWithChange= findHeadersWithMatchingSiblings(headerRows, changeRows);

  selector.addEventListener('change', event => {
    switch (event.target.value) {
      case 'all':
        showRows(flagRows);
        showRows(headerRows);
        break;
      case 'red/amber':
        hideRows(flagRows);
        hideRows(headerRows);
        showRows(amberRowsLatest);
        showRows(redRowsLatest);
        showRows(headersWithAmberLatest);
        showRows(headersWithRedLatest);
        break;
      case 'red/amber-ever':
        hideRows(flagRows);
        hideRows(headerRows);
        showRows(amberRowsEver);
        showRows(redRowsEver);
        showRows(headersWithAmberEver);
        showRows(headersWithRedEver);
        break;
      case 'red':
        hideRows(flagRows);
        hideRows(headerRows);
        showRows(redRowsLatest);
        showRows(headersWithRedLatest);
        break;
      case 'red-ever':
        hideRows(flagRows);
        hideRows(headerRows);
        showRows(redRowsEver);
        showRows(headersWithRedEver);
        break;
      case 'amber':
        hideRows(flagRows);
        hideRows(headerRows);
        showRows(amberRowsLatest);
        showRows(headersWithAmberLatest);
        break;
      case 'amber-ever':
        hideRows(flagRows);
        hideRows(headerRows);
        showRows(amberRowsEver);
        showRows(headersWithAmberEver);
        break;
      case 'flag-changed':
        hideRows(flagRows);
        hideRows(headerRows);
        showRows(changeRows);
        showRows(headersWithChange);
        break;
    }
  });
};
