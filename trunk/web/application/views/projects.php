<html>
<head>
<link rel="stylesheet" type="text/css" href="<?=site_url('css/basic.css')?>" />
</head>

<body>
	<?php 
	if (isset($message)) {
		echo '<div id="message">';
		echo $message;
		echo '</div>';
	}
	?>
	<div id='adding'>
		<h1>Adding</h1>
		<div class='form_container'>	
			<?=form_open('projects/add')?>
				<?=form_fieldset('Project adding form')?>
				<div class='textfield'>
					<?=form_label('project_name', 'project_name')?>
					<?=form_input('project_name');?>
				</div>
				<div class='textfield'>
					<?=form_label('description', 'project_desc')?>
					<?=form_textarea('project_desc')?>
				</div>
				<div class='buttons'>
					<?=form_submit('add', 'Add')?>
				</div>
			<?=form_close();?>
		</div>
	</div>
	<h1>Projects</h1>
	<div id='projects'></div>
</body>
</html>

<script type='text/javascript' src="<?=site_url('js/jquery-1.5.1.min.js')?>">
</script>
<script>
	function get(s)
	{
		$.ajax({
		  url: "<?=site_url()?>"+s+'/get',
		  data: "",
		  success: function(data){
			$('#'+s).html(data);
		  }
		});
	}
	$(document).ready(function() {
		<?php
		if (! isset($action) or $action != "adding") {
			echo "$('#adding').hide();";
		}
		?>
		get('projects');
		get('users');
	});
	function remove(id,s) 
	{
		$.ajax({
		  url: "<?=site_url()?>"+s+'/remove',
		  data: 'id='+id,
		  success: function(data){
				get(s);
		  }
		});
	}
</script>