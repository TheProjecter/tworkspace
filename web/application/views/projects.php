<?php include_once './inc/header.php'; ?>

	<div id='create'>
		<h1>create</h1>
		<div class='form_container'>	
			<?=form_open('projects/create')?>
				<?=form_fieldset('project creation form')?>
				<div class='textfield'>
					<?=form_label('name', 'project_name')?>
					<?=form_input('project_name');?>
				</div>
				<div class='textfield'>
					<?=form_label('description', 'project_desc')?>
					<?=form_textarea('project_desc')?>
				</div>
				<div id="attach">
					<input type='hidden' id='n_attachments' value='0' />
					<?=form_button('attach', 'attach file', 'onClick="add_attachment()"')?>
				</div>
				<div class='buttons'>
					<?=form_submit('create', 'create')?>
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

	function delete_attachment(i)
	{
		$("#t1"+i).remove();
		$("#l1"+i).remove();
		$("#l2"+i).remove();
		$("#t2"+i).remove();
		$("#b"+i).remove();
		$("#f"+i).remove();
		html=$('#attach').html();
		$('#attach').html(html);
	}

	function add_attachment()
	{
		i=$('#n_attachments').val();
		html=$('#attach').html();
		form='<div id="f'+i+'" class="textfield">' +
			'<input type=hidden name="id['+i+']" value="'+i+'" />' +
			'<label id="l1'+i+'" for="project_attachment_name[' + i + ']">name</label>' +
			'<input id="t1'+i+'" type="text" name="project_attachment_name[' + i + ']" /><br>' + 
			'<label id="l2'+i+'" for="project_attachment[' + i + ']">file</label>' +
			'<input id="t2'+i+'" type="file" name="project_attachment[' + i + ']"<br>' + 
			'<button id="b'+i+'" onClick=delete_attachment(' + i + ')>delete</button>' +
			'</div>';
		$('#attach').html(html+form);
		$('#n_attachments').val(++i);
	}
</script>
