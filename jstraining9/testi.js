
var arvattava = Math.floor(Math.random()*3)+1;
var yritykset = 0;
while(arvaus != arvattava && yritykset < 2 ){
    yritykset++;
    var arvaus =  prompt("arvaa numero?");
    if(arvattava == arvaus){
        console.log("Oikein arvattu");
    }
    else {
        console.log("Väärin");
}
}