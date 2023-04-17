//
//   function search() {
//         var input = document.getElementById("searchbar");
//         var upper = input.value.toUpperCase();
//         var collonne = document.getElementById("table").getElementsByTagName("tr");
//
//           for (var i = 0; i < collonne.length; i++) {
//             var elements = collonne[i].getElementsByTagName("td");
//             var valide = false;
//             for (var j = 0; j < elements.length; j++) {
//               var element = elements[j];
//               if (element) {
//                 var text = element.textContent || element.innerText;
//                 if (text.toUpperCase().indexOf(upper) > -1) {
//                   valide = true;
//                   break;
//                 }
//               }
//             }
//             collonne[i].style.display = valide ? "" : "none";
//           }
//         }
//         document.querySelector("form").addEventListener("submit", function(e) {
//           e.preventDefault();
//           search();
//     })
//         function panier() {
//             window.location.href = "panier.html"
//         }
//
//   function displayItem(item) {
//     var todocontainer = document.getElementById('product-container')
//     var newItem = document.createElement('div')
//     newItem.innerText = item
//     todocontainer.appendChild(newItem)
// }
//     function onButton(itemName) {
//         fetch('/add-item', {
//             method: 'POST',
//             body: JSON.stringify({ item: itemName }),
//             headers: { 'Content-Type': 'application/json' }
//         })
//         .then(response => response.json())
//         .then(data => {
//             if (data.success) {
//                 displayItem(itemName);
//             } else {
//                 alert(data.message);
//             }
//         })
//         .catch(error => {
//             console.error(error);
//             alert('Une erreur s\'est produite.');
//         });
// }
