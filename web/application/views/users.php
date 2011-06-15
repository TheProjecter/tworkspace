<?php include_once './inc/header.php'; ?>

	<div id='create'>
		<h1>create</h1>
		<div class='form_container'>	
			<?=form_open_multipart('users/create')?>
				<?=form_fieldset('user createion form')?>
				<div class='textfield'>
					<?=form_label('email', 'create_email')?>
					<?=form_input('create_email');?>
				</div>
				<div class='textfield'>
					<?=form_label('username', 'create_username')?>
					<?=form_input('create_username');?>
				</div>
				<div class='textfield'>
					<?=form_label('password', 'create_password')?>
					<?=form_password('create_password')?>
				</div>
				<div class='textfield'>
					<?=form_label('project', 'create_project')?>
					<?=form_dropdown('create_project', $projects)?>
				</div>
				<div class='textfield'>
					<?=form_label('manager', 'create_manager')?>
					<?=form_dropdown('create_manager', $managers)?>
				</div>
				<div class='textfield'>
					<?=form_label('privilege', 'create_privilege')?>
					<?=form_dropdown('create_privilege', $privilege)?>
				</div>
				<div class='textfield'>
					<?=form_label('photo', 'create_photo')?>
					<?=form_upload('create_photo')?>
				</div>
				<div class='buttons'>
					<?=form_submit('create', 'create')?>
				</div>
			<?=form_close();?>
		</div>
	</div>

	<h1>users</h1>
	<a href='<?=site_url('/users/create')?>'>create</a>
	<div id='users'></div>

<?php include_once './inc/footer.php'; ?>

<script>
	$(document).ready(function() {
		get('users');
	});
</script>
