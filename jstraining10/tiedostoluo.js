var modu = require("fs")
var sisalto = "exports.kerto = function(x,y,z){return x*y*z}"
for(let i = 1; i < 4; i++){
    modu.writeFile("./uusi"+i+".js",sisalto, function(err) {
        if (err) throw err
        console.log('Saved!')
    })

}