//kysyy käyttäjän ikän
console.log("kuinka vanha olet?")
var ikä = readline();
var alaikäraja = 17
//vertaa kysyttyä ikää alaikärajaan
if (ikä > alaikäraja) {
    console.log("Olet täysi-ikäinen, ikäsi on" + " " + ikä);
  } else if (ikä < testiikä) {
    console.log("Olet ala-ikäinen, ikäsi on" + " " + ikä );
  
  }
 else  {
    console.log("jotain meni pieleen" );
  
  }