<html lang="en">
<head>
	<meta charset="utf-8">
	<title>Welcome to tworkspace</title>

<link rel="stylesheet" type="text/css" href="<?=site_url('css/basic.css')?>" />

</head>
<body>


	<table>
	<tr> <td>  
<?php
	if($this->session->userdata('logged_in')) {
		echo '<a href="' . site_url('users/logout') . '">logout</a>';
	} else {
		echo '<a href="' . site_url('users/login') . '">login</a>';
	}
?>
	</td> </tr>
	<tr> <td> <a href="<?=site_url('')?>">home</a> </td> </tr>
	<tr> <td> <a href="<?=site_url('projects')?>">projects</a></td></tr>
	<tr> <td> <a href="<?=site_url('privileges')?>">privileges</a></td></tr>
	<tr> <td> <a href="<?=site_url('users')?>">users</a></td></tr>
	</table>

	<?php 
	if (isset($message)) {
		echo '<div id="message">';
		echo $message;
		echo '</div>';
	}
	?>
