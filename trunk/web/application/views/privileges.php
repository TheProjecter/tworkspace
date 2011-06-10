<?php include_once './inc/header.php'; ?>

	<div id='create'>
		<h1>create</h1>
		<div class='form_container'>	
			<?=form_open('privileges/create')?>
				<?=form_fieldset('Privilege createion form')?>
				<div class='textfield'>
					<?=form_label('Name', 'create_name')?>
					<?=form_input('create_name');?>
				</div>
				<div class='textfield'>
					<?=form_label('Description', 'create_description')?>
					<?php
					$data = array(
							'name'        => 'create_description',
							'id'          => 'create_description',
							'value'       => '',
							'maxlength'   => '300',
							'size'        => '20',
							'style'       => 'width:50%;height:140px',
							);
					echo form_textarea($data);
					?>
				</div>
				<div class='textfield'>
					<?=form_label('watch projects', 'create_options[watch_projects]')?>
					<?=form_checkbox('create_options[watch_projects]', 'accept', FALSE)?>
				</div>
				<div class='textfield'>
					<?=form_label('watch users', 'create_options[watch_users]')?>
					<?=form_checkbox('create_options[watch_users]', 'accept', FALSE)?>
				</div>
				<div class='textfield'>
					<?=form_label('watch privileges', 'create_options[watch_privileges]')?>
					<?=form_checkbox('create_options[watch_privileges]', 'accept', FALSE)?>
				</div>
				<div class='textfield'>
					<?=form_label('create project', 'create_options[create_project]')?>
					<?=form_checkbox('create_options[create_project]', 'accept', FALSE)?>
				</div>
				<div class='textfield'>
					<?=form_label('create user', 'create_options[create_user]')?>
					<?=form_checkbox('create_options[create_user]', 'accept', FALSE)?>
				</div>
				<div class='textfield'>
					<?=form_label('create privilege', 'create_options[create_privilege]')?>
					<?=form_checkbox('create_options[create_privilege]', 'accept', FALSE)?>
				</div>
				<div class='buttons'>
					<?=form_submit('create', 'Create')?>
				</div>
			<?=form_close();?>
		</div>
	</div>

	<h1>privileges</h1>
	<a href='<?=site_url('/privileges/create')?>'>create</a>
	<div id='privileges'></div>

<?php include_once './inc/footer.php'; ?>

<script>
	$(document).ready(function() {
		get('privileges');
	});
</script>
