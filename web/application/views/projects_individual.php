<?php include_once './inc/header.php'; ?>

	<div id='project'>
		<h1><?=$project['name']?></h1>
		<div class='form_container'>	
			<?=form_open('projects/update')?>
				<?=form_fieldset('project information')?>
				<div class='textfield'>
					<?=form_label('id', 'id')?>
					<?$data=array('value'=>$project['id'],'name'=>'id','disabled'=>'diabled')?>
					<?=form_input($data)?>
				</div>
				<div class='textfield'>
					<?=form_label('description', 'description')?>
					<?=form_textarea('description', $project['description'])?>
				</div>
				<div class='buttons'>
					<?=form_submit('update', 'update')?>
				</div>
			<?=form_close();?>
		</div>
	</div>

<?php include_once './inc/footer.php'; ?>

<script>
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
			'<label id="l1'+i+'" for="project_attachment_name[' + i + ']">name</label>' +
			'<input id="t1'+i+'" type="text" name="project_attachment_name[' + i + ']" /><br>' + 
			'<label id="l2'+i+'" for="project_attachment[' + i + ']">attachment</label>' +
			'<input id="t2'+i+'" type="file" name="project_attachment[' + i + ']"<br>' + 
			'<button id="b'+i+'" onClick=delete_attachment(' + i + ')>delete</button>' +
			'</div>';
		$('#attach').html(html+form);
		$('#n_attachments').val(++i);
	}
</script>
