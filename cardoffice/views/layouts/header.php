
<?php

$con = mysqli_connect("localhost","root","","cardoffice");
$id_rol=3;
$query = "SELECT * FROM rol_menu rm, menu m WHERE rm.id_rol=".$_SESSION['usuario'][0]['id_rol']." AND rm.id_menu =m.id";
$consulta = mysqli_query($con,$query);
?>

<!DOCTYPE HTML5>
<html>
    <head>
    <title>Cardoffice</title>
    
        <script src="<?=base_url?>assets/js/homePanel.js"></script>
        <script src="//code.jquery.com/jquery-1.11.1.min.js"></script>
        <link href="//netdna.bootstrapcdn.com/bootstrap/3.2.0/css/bootstrap.min.css" rel="stylesheet" id="bootstrap-css">
        <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.8.1/css/all.css" integrity="sha384-50oBUHEmvpQ+1lW4y57PTFmhCaXp0ML5d60M1M7uH2+nqUivzIebhndOJK28anvf" crossorigin="anonymous">
        <link href="https://use.fontawesome.com/releases/v5.0.6/css/all.css" rel="stylesheet"/>
        <link href="<?=base_url?>assets/css/home.css" rel="stylesheet" >
        <script src="//netdna.bootstrapcdn.com/bootstrap/3.2.0/js/bootstrap.min.js"></script>
      
    </head>
<body>

<div class="row">