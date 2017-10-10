function like(elem) {
  if (elem.classList.contains('icon--selected')) {
    elem.classList.remove('icon--selected');
  } else {
    elem.classList.add('icon--selected');
  }
}
