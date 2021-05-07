/*
  index.js
  --------
  Tässä sovelluksessa yhdistetään NodeJS:llä MySQL tietokantaan "clients".
  
  Sivustoa ylläpitää express nodejs kirjasto, asennetaan "npm install express"
  Sivustoa voidaan testata localhost:3000 jonka tulisi vastata Hello World!

  Express JS polku suorittaa funktion jonka perusteella toimenpide tehdään.

  TEHTÄVÄ:
   - Luo toiminnot loppuun. 
     - getClients
     - getClient(id)
     - addClient(data)
     - updateClient(id)
     - deleteClient(id)
     - searchClientsByName(val)

   - Testaa toimintaa
     - Lisää asiakkaat: Jalo IT Oy, Taitotalo, McDonald's, Acme Corporation
     - Näytä kaikki asiakkaat
     - Hae asiakas nimellä McDonald's
     - Poista asiakas ID:llä 1
     - Päivitä asiakas "McDonald's" otsikolle Hesburger

   - Lisätehtävä, kuten testauksessa huomattua tiedot eivät tule näkyviin sivulle.
     - Toiminto johtuu koska Javascript toiminnot voivat toimia asynkronisesti, tieto ei ole vielä valmistunut ja jatketaan jo toiseen tehtävään.
     - Alla esimerkki asynkronisesta funktiosta ja että funktiota käsketään odottamaan.

#START query.js
module.exports = async (conn, q, params) => new Promise(
  (resolve, reject) => {
    const handler = (error, result) => {
        if (error) {
        reject(error);
        return;
      }
      resolve(result);
    }
    conn.query(q, params, handler);
});
#END query.js

var query = require('./query.js');

app.get('/asiakas/kaikki', async function (req, res) {
  res.json(await haeAsiakkaat())
}) 

async function luoAsiakas(nimi){
  var sql = "INSERT INTO Asiakkaat (Nimi) VALUES (?)";
  const results = await query(con, sql, [nimi]).catch(console.log);
  console.log(results);
  return results
}   

*/

var mysql = require('mysql');
var express = require('express');
var app = express();
const port = 3000

app.get('/', (req, res) => {
  res.send('Hello World!')
})

app.get('/api/clients/', function (req, res) {
  res.send(getClients())
})

app.get('/api/clients/:id', function (req, res) {
    res.send(getClient(req.params.id))
})

app.post('/api/clients/', function (req, res) {
  console.log('Got body:', req.body);
  res.send(addClient(data))
})

app.put('/api/clients/:id', function (req, res) {
  console.log('Got body:', req.body);
  res.send(updateClient(req.params.id, req.body))
})

app.delete('/api/clients/:id', function (req, res) {
    res.send(deleteClient(req.params.id))
})

app.get('/search/clients/byName', function (req, res) {
  res.send(searchClientsByName(req.query.val))
})

app.listen(port, () => {
  console.log(`Example app listening at http://localhost:${port}`)
})


var con = mysql.createConnection({
  host: "localhost",
  user: "root",
  password: "",
  database: "demo"
});

con.connect(function(err) {
  if (err) throw err;
  console.log("Connected!");
});

function addClient(data){
  /* https://www.w3schools.com/nodejs/nodejs_mysql_insert.asp */
  /* https://www.veracode.com/blog/secure-development/how-prevent-sql-injection-nodejs */
  var sql = "INSERT INTO CLIENTS (ClientName) VALUES (?)";
  con.query(sql, [data.nimi], function (err, result) {
    if (err) throw err;
    console.log("Client "+data.nimi+" created");
    return "Client "+nimi+" created";
  });
}

function getClients(){
  /* https://www.w3schools.com/nodejs/nodejs_mysql_select.asp */
  var sql = "SELECT * FROM Clients";
  con.query(sql,function(err,result){
    if(err) throw err;
    console.log(result)
    return result;
  });
}

function getClient(id){
  /* https://www.w3schools.com/nodejs/nodejs_mysql_select.asp */
  var sql = "SELECT * FROM Clients WHERE id = ?";
  con.query(sql,function(err,result){
    if(err) throw err;
    console.log(result)
    return result;
  });
}

function updateClient(id, data){
  /* https://www.w3schools.com/nodejs/nodejs_mysql_update.asp */
  var sql = "UPDATE Clients SET Clientname = ? WHERE id = ?";
}

function deleteClient(id){
  /* https://www.w3schools.com/nodejs/nodejs_mysql_delete.asp */
  var sql = "DELETE FROM Clients WHERE id = ?";
}

function searchClientsByName(val){
    /* https://www.w3schools.com/nodejs/nodejs_mysql_where.asp */
  var sql = "SELECT * FROM Clients LIKE %?%";
}


/*

curl http://localhost:3000/api/clients -X POST -d ’clientname=Taitotalo’
Invoke-WebRequest -Method POST http://localhost:3000/api/clients -Body @{clientname=Taitotalo’}

curl http://localhost:3000/api/clients -X GET
Invoke-WebRequest -Method GET http://localhost:3000/api/clients

curl http://localhost:3000/api/clients/1 -X GET
Invoke-WebRequest -Method GET http://localhost:3000/api/clients/1

curl http://localhost:3000/api/clients/1 -X PUT -d ’clientname=Hesburger’
Invoke-WebRequest -Method PUT http://localhost:3000/api/clients/1 -Body @{clientname= Hesburger’}

curl http://localhost:3000/api/clients/1 -X DELETE -d 
Invoke-WebRequest -Method DELETE http://localhost:3000/api/clients/1

curl http://localhost:3000/search/clients/byName?val=Mäkkäri -X GET
Invoke-WebRequest -Method GET http://localhost:3000/search/clients/byName?val=Mäkkäri

*/