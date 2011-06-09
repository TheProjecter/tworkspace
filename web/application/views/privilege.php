<html>
<head>
<link rel="stylesheet" type="text/css" href="<?=site_url('css/basic.css')?>" />
</head>

<body>
	<a href="<?=site_url('')?>">home</a>
	<?php 
	if (isset($message)) {
		echo '<div id="message">';
		echo $message;
		echo '</div>';
	}
	?>
	<div id='create'>
		<h1>create</h1>
		<div class='form_container'>	
			<?=form_open('privilege/create')?>
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
					<?=form_label('Add Project', 'create_options[create_project]')?>
					<?=form_checkbox('create_options[create_project]', 'accept', FALSE)?>
				</div>
				<div class='textfield'>
					<?=form_label('Add User', 'create_options[create_user]')?>
					<?=form_checkbox('create_options[create_user]', 'accept', FALSE)?>
				</div>
				<div class='textfield'>
					<?=form_label('Add Privilege', 'create_options[create_privilege]')?>
					<?=form_checkbox('create_options[create_privilege]', 'accept', FALSE)?>
				</div>
				<div class='buttons'>
					<?=form_submit('create', 'Create')?>
				</div>
			<?=form_close();?>
		</div>
	</div>
	<h1>Privileges</h1>
	<div id='privilege'></div>
	<a href="<?=site_url('')?>">back</a>
</body>
</html>

<script type='text/javascript' src="<?=site_url('js/jquery-1.5.1.min.js')?>">
</script>
<script>
	$(document).ready(function() {
		get('privilege');
<?php 
	if(!isset($action) or $action != "create") {
		echo "\t\t$('#create').hide();\n";
	}
?>
	});
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
