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
