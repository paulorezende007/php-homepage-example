<?php
/* Include the MySQLi (procedural-style) connection script */
include 'mysql.php';
/* Query */
$query = 'SELECT * FROM products';
/* Execute the query */
$result = mysqli_query($mysqli, $query);
/* Check for errors */
if (!$result)
{
   echo 'Query error: ' . mysqli_error($mysqli);
   die();
}
/* Iterate through the result set */
while ($row = mysqli_fetch_assoc($result))
{
   echo 'Product Name: ' . $row['name'] . ', Price: ' . $row['price'] . '<br>';
}