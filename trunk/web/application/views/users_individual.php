<?php include_once './inc/header.php'; ?>

	<h1><?=$user['name']?></h1>
	<table>
	<tr>
	<td> <img height="150" src=<?=site_url("/uploads/".$user['photo'])?> /> </td>
	<td><table>
	<tr><td>id</td><td><?=$user['id']?></td></tr>
	<tr><td>email</td><td><?=$user['email']?></td></tr>
	<tr><td>project</td><td><?=$user['project']?></td></tr>
	<tr><td>manager</td><td><?=$user['manager']?></td></tr>
	<tr><td>privilege</td><td><?=$user['privilege']?></td></tr>
	<tr><td>creation date</td><td><?=$user['date']?></td></tr>
	<tr><td>last modified</td><td><?=$user['modified']?></td></tr>
	<tr><td>last login</td><td><?=$user['last_login']?></td></tr>
	</table></td>
	</tr>
	</table>

<?php include_once './inc/footer.php'; ?>
