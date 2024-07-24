// Get the select element
const selectElement = document.querySelector('.Widget_GroupOverview select');

// Initialize the variable with the current value of the select element
let selectedValue = selectElement.value;

// Function to update the variable when the select value changes
function updateSelectedValue() {
    selectedValue = selectElement.value;
}

// Add an event listener to the select element to detect changes
selectElement.addEventListener('change', updateSelectedValue);

///////////////////////////////////////////////

const findMatchingRows = (rows, selector) => {
  const matchingRows = [];

  rows.forEach(row => {
    const hasMatchingCell = row.querySelector(selector);
    if (hasMatchingCell) {
      matchingRows.push(row);
    }
  });

  return(matchingRows);
};

const findHeadersWithMatchingSiblings = (headers, targets) => {
  const matchingHeaders = [];

  headers.forEach(header => {
    const nextRow = header.nextElementSibling;
    const nextNextRow = nextRow ? nextRow.nextElementSibling : null;

    const isNextRowTarget = nextRow && targets.includes(nextRow);
    const isNextNextRowTarget = nextNextRow && targets.includes(nextNextRow);

    if (isNextRowTarget || isNextNextRowTarget) {
      matchingHeaders.push(header);
    }
  });

  return matchingHeaders;
};

const hideRow = (row) => {
  row.style.display = 'none';
};
const showRow = (row) => {
  row.style.display = 'table-row';
};
const hideRows = (rows) => {
  rows.forEach(hideRow);
};
const showRows = (rows) => {
  rows.forEach(showRow);
};

const rows = document.querySelectorAll('#FlagOverTime tbody tr');
const headerRows = document.querySelectorAll('#FlagOverTime tbody tr.gt_group_heading_row');

const flagRows = findMatchingRows(rows, 'td');
const amberRowsEver = findMatchingRows(rows, 'td[style*="background-color: #FFBF00"]');
const amberRowsLatest = findMatchingRows(rows, 'td:last-of-type[style*="background-color: #FFBF00"]');
const redRowsEver = findMatchingRows(rows, 'td[style*="background-color: #FF0040"]');
const redRowsLatest = findMatchingRows(rows, 'td:last-of-type[style*="background-color: #FF0040"]');
const headersWithRedLatest = findHeadersWithMatchingSiblings(headerRows, redRowsLatest);

hideRows(flagRows);
hideRows(headerRows);
showRows(redRowsLatest);
showRows(headersWithRedLatest);

// flagRows.forEach(hideRow);
// redRowsLatest.forEach(showRow);
