<?php include("includes/a_config.php");?>

<!DOCTYPE html>
<html>
<head>
	<?php include("includes/head-tag-contents.php");?>
</head>
<body>

<?php include("includes/design-top.php");?>
<?php include("includes/navigation.php");?>

<div class="container" id="main-content">
	<p></p>
	<h3>Nome da Instância: </h3>
	<p></p>
	<h3 style="color:blue;"><b><?php print gethostname();?></b></h3>
	<p></p>
	<p></p>
	<p></p>
	<p></p>
	<?php include("includes/footer.php");?>
</div>

</body>
</html>