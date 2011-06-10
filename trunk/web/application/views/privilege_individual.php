<?php include_once './inc/header.php'; ?>

	<h1><?=$privilege['name']?></h1>
	<table>
	<tr><td>id</td><td><?=$privilege['id']?></td></tr>
	<tr><td>description</td><td><?=$privilege['description']?></td></tr>
	<tr><td>code</td><td><?=$privilege['code']?></td></tr>
	</table>

<?php include_once './inc/footer.php'; ?>
