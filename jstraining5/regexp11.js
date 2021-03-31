var merkkijono= "Tämä on varsin pitkä merkkij0n0n, ja siinä on eri asioita."
var vertailu = new RegExp(/[^a-zA-ZäöüßÄÖÜ]/)
if (vertailu.test(merkkijono)){
console.log("merkkijono ok")
}else {
console.log("merkkijono virheellinen")
}