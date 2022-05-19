function char_count(str, a) {
  var a = 'a';
  for (var i = 0; i < str.length; i++) {
    if (str.charAt(i) == a) {
      a += 1;
    }
  }
}