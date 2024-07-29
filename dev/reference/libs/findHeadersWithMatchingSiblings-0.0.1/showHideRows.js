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
