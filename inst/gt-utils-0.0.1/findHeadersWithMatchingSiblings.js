const findHeadersWithMatchingSiblings = (headers, targets) => {
  const headersArray = Array.from(headers);
  const matchingHeaders = [];

  headers.forEach(header => {
    let sibling = header.nextElementSibling;
    let foundTarget = false;

    // Iterate through all siblings until the next header or end of the container
    while (sibling && !headersArray.includes(sibling)) {
      if (targets.includes(sibling)) {
        foundTarget = true;
        break;
      }
      sibling = sibling.nextElementSibling;
    }

    if (foundTarget) {
      matchingHeaders.push(header);
    }
  });

  return matchingHeaders;
};
