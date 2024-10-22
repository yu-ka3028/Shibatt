// document.addEventListener('DOMContentLoaded', function (e) {
//   const urlParams = new URLSearchParams(window.location.search);
//   if (urlParams.has('liff')) {
//     liff.init(function (data) {
//       initializeApp(data);
//     });
//   }
// });

// function initializeApp(data) {
//   if (!liff.isLoggedIn()) {
//     liff.login();
//   } else {
//     fetch('/user_sessions/destroy', {
//       method: 'POST',
//       headers: {
//         'Content-Type': 'application/json',
//         'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
//       }
//     })
//     .then(response => {
//       if (!response.ok) {
//         throw new Error('Network response was not ok');
//       }
//       return response.json();
//     })
//     .then(data => {
//       console.log('Success:', data);
//       liff.logout();
//     })
//     .catch((error) => {
//       console.error('Error:', error);
//     });
//   }
// }