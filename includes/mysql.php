<?php
/* Host name of the MySQL server */
$host = '10.35.35.3';
/* MySQL account username */
$user = 'root';
/* MySQL account password */
$passwd = 'DB_PASSWD';#'hF5nb41P6@re.vPH';
/* The schema you want to use */
$database = 'website-db';
/* Connection with MySQLi, procedural-style */
$mysqli = mysqli_connect($host, $user, $passwd, $database);
/* Check if the connection succeeded */
if (!$mysqli)
{
   echo 'Connection failed<br>';
   echo 'Error number: ' . mysqli_connect_errno() . '<br>';
   echo 'Error message: ' . mysqli_connect_error() . '<br>';
   die();
}
echo 'Successfully connected!<br>';
echo '<br>';