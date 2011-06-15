<?php include_once './inc/header.php'; ?>

	<div id='project'>
		<h1><?=$project['name']?></h1>
		<div class='form_container'>	
			<?=form_open_multipart('projects/update')?>
				<?=form_fieldset('project information')?>
				<div class='textfield'>
					<?=form_label('id', 'id')?>
					<?$data=array('value'=>$project['id'],'name'=>'id','readonly'=>'readonly')?>
					<?=form_input($data)?>
				</div>
				<div class='textfield'>
					<?=form_label('name', 'project_name')?>
					<?=form_input('project_name', $project['name'])?>
				</div>
				<div class='textfield'>
					<?=form_label('description', 'project_desc')?>
					<?=form_textarea('project_desc', $project['description'])?>
				</div>
				<?=form_button('attach', 'attach file', 'onClick="add_attachment()"')?>
				<div class='textfield'>
					<?=form_label('attachments', 'attachments')?><br>
					<div id='attachments'></div>
				</div>
				<div class='buttons'>
					<?=form_submit('update', 'update')?>
				</div>
			<?=form_close();?>
		</div>
	</div>

<?php include_once './inc/footer.php'; ?>
<?php include_once './inc/attachments.php'; ?>

<script>

	$(document).ready(function() {
		get_attachments('<?=$project['name']?>');
	});

</script>


