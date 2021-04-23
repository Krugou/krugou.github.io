const readline = require("readline")
const rl = readline.createInterface({
    input: process.stdin,
    output: process.stdout
})
let i = 1
const arvattava = Math.floor(Math.random()*101);
console.log("Arvaa luku väliltä 0 - 100.\nSinulla on kymmenen arvausta")
var recursiveAsyncReadLine = function (i) {
    rl.question(i+1+". arvaus: ", function (arvaus) {
      if (i >= 9) {
        return rl.close(); 
      }
      else if (arvaus == arvattava) {
        console.log("Arvasit oikein. Numero on "+arvattava);
        return rl.close(); 
      }
      else {
        console.log("Arvasit väärin. Arvaa uudelleen.");
        recursiveAsyncReadLine(++i); 
      }
    });
  };
  recursiveAsyncReadLine(0);
rl.on("close", function(){
    console.log("\nBye bye. =(")
    process.exit(0)
})