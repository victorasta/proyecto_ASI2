<?php 
class Database{
    public static function connect(){
        $db = new mysqli("localhost","root","","cardoffice");
        $db->query("SET NAMES 'UTF8'");
        return $db;
    }

    
}