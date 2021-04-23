exports.Metodi1 = function (x,y){
    return x + y

}
exports.Metodi2 = function (x,y,z){
    return x + y + z

}
exports.Metodi3 = function (x){
    return console.log(x)

}
exports.Metodi4 = function reverseString(str) {
    const arrayStrings = str.split(""); 
    const reverseArray = arrayStrings.reverse();
    const joinArray = reverseArray.join("");
    return joinArray;
}
 

exports.Metodi5 = function sum_digits_from_string(dstr) {
    var dsum = 0;
  
    for (var i = 0; i < dstr.length; i++)
    {
  
      if (/[0-9]/.test(dstr[i])) dsum += parseInt(dstr[i])
    }
    return dsum;
  }
