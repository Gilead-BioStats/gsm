function number_to_array(num) {
   if (Array.isArray(num)) {
      return num
   } else if (num === null) {
      return []
   } else {
      return [num]
   }
}
