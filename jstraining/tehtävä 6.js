function sekalasku(arg1, arg2) {
  if (arg1 > 0 && arg2 > 0) {
    return arg1 - arg2;
  } else if (arg1 < 0 && arg2 < 0) {
    return arg1 * arg2;
  } else {
    return arg1 / arg2;

  }
}

console.log(sekalasku(5, 22));