function isEven(n) {
    n = n % 2;
    if (n) {
        return 0;
    }
    else {
        return 1;
    }
}
function isOdd(n) {
    n = n % 2;
    if (n) {
        return 1;
    }
    else {
        return 0;
    }
}
module.exports = { isEven, isOdd }