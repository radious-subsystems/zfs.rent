const urlParams = new URLSearchParams(window.location.search);
console.log(urlParams);
const id = urlParams.get('id');
console.log(id);
window.localStorage.set('session_id', id);
