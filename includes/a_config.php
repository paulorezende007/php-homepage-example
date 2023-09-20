<?php
	switch ($_SERVER["SCRIPT_NAME"]) {
		case "/about.php":
			$CURRENT_PAGE = "About"; 
			$PAGE_TITLE = "WebSite - About";
			break;
		case "/connectdb.php":
			$CURRENT_PAGE = "Connect DB"; 
			$PAGE_TITLE = "WebSite - Conect DB";
			break;
		default:
			$CURRENT_PAGE = "Index";
			$PAGE_TITLE = "WebSite - Home";
	}
?>