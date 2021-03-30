//Luodaan oliotyyppi
var v1 = {
    nimi: "porkkana",
    hinta: 5.0
    }
    var v2 = {
    nimi: "retiisi",
    hinta: 2.0
    }
    var v3 = {
    nimi: "peruna",
    hinta: 1.0
    }
    
    
    
    
    //Funktio saa numeron. Arvotaan numeron monta kertaa v1-v3 olio taulukkoon, joka palautetaan
    function arvoSatunnainen(numero){
    var arr = new Array()
    for(var i = 0; i < numero; i++){
    var olionNimi = "v"+(Math.floor(Math.random()*3)+1)
    console.log(olionNimi)
    arr.push(v2)
    }
    return arr
    }
    
    
    
    
    //Funktio joka laskee taulukon olioiden hinta-muuttujien kokonaissumman. Ja palauttaa sen.
    function laskeKokonaisHinta(arr){
    var tulos = 0;
    for(var i = 0; i < arr.length; i++){
    tulos += arr[i].hinta
    }
    return tulos
    }
    
    
    
    
    //Pieni testaus
    var vihanneskori = arvoSatunnainen(5)
    console.log(vihanneskori.length)
    console.log(laskeKokonaisHinta(vihanneskori))