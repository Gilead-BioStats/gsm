function addCovariateDropdown() {

  const main = window.location.href

  console.log('hello')


  const dropdowns = [...document.querySelectorAll('.kri-dropdown')]

  dropdowns.map(el => {
      el.addEventListener("change", function(e){
          var selected = document.getElementById(`${e.target.value}`)
          window.location.href = `${main}#${selected.className}`
      })
  })

  console.log(main)

}


document.addEventListener("DOMContentLoaded", function () {
  addCovariateDropdown()
})
