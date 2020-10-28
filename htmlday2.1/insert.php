<?php
$etunimi = $_POST['etunimi'];
$sukunimi = $_POST['sukunimi'];
$sukupuoli = $_POST['sukupuoli'];
$salasana = $_POST['salasana'];
$phoneCode = $_POST['phoneCode'];
$phone = $_POST['phone'];
if (!empty($etunimi) || !empty($sukunimi) || !empty($sukupuoli) || !empty($salasana) ) {
 $host = "localhost";
    $dbUsername = "root";
    $dbPassword = "";
    $dbname = "krugou";
    //create connection
    $conn = new mysqli($host, $dbUsername, $dbPassword, $dbname);
    if (mysqli_connect_error()) {
     die('Connect Error('. mysqli_connect_errno().')'. mysqli_connect_error());
    } else {
     $SELECT = "SELECT salasana From register Where salasana = ? Limit 1";
     $INSERT = "INSERT Into register (etunimi, sukunimi, sukupuoli, salasana, ) values(?, ?, ?, ?, ?, ?)";
     //Prepare statement
     $stmt = $conn->prepare($SELECT);
     $stmt->bind_param("s", $salasana);
     $stmt->execute();
     $stmt->bind_result($salasana);
     $stmt->store_result();
     $stmt->store_result();
     $stmt->fetch();
     $rnum = $stmt->num_rows;
     if ($rnum==0) {
      $stmt->close();
      $stmt = $conn->prepare($INSERT);
      $stmt->bind_param("ssssii", $etunimi, $sukunimi, $sukupuoli, $salasana, );
      $stmt->execute();
      echo "New record inserted sucessfully";
     } else {
      echo "Someone already register using this salasana";
     }
     $stmt->close();
     $conn->close();
    }
} else {
 echo "All field are required";
 die();
}
?>