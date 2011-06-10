<?php include_once './inc/header.php'; ?>

	<div id='create'>
		<h1>Adding</h1>
		<div class='form_container'>	
			<?=form_open('projects/create')?>
				<?=form_fieldset('Project creation form')?>
				<div class='textfield'>
					<?=form_label('name', 'project_name')?>
					<?=form_input('project_name');?>
				</div>
				<div class='textfield'>
					<?=form_label('description', 'project_desc')?>
					<?=form_textarea('project_desc')?>
				</div>
				<div class='buttons'>
					<?=form_submit('create', 'Create')?>
				</div>
			<?=form_close();?>
		</div>
	</div>

	<h1>projects</h1>
	<a href='<?=site_url('/projects/create')?>'>create</a>
	<div id='projects'></div>

<?php include_once './inc/footer.php'; ?>

<script>
	$(document).ready(function() {
		get('projects');
	});
</script>
