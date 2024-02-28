const data = document.querySelectorAll("[id*='_data_']");

hide_data = function(){
  for (let i = data.length - 1; i >= 0; i -= 1) {
  data[i].style.display = 'none';
  }
}

hide_data()



