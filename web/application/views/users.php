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
			<?=form_open('users/add')?>
				<?=form_fieldset('User adding form')?>
				<div class='textfield'>
					<?=form_label('user_name', 'user_name')?>
					<?=form_input('user_name');?>
				</div>
				<div class='textfield'>
					<?=form_label('password', 'user_pass')?>
					<?=form_password('user_pass')?>
				</div>
				<div class='buttons'>
					<?=form_submit('add', 'Add')?>
				</div>
			<?=form_close();?>
		</div>
	</div>
	<h1>Users</h1>
	<div id='users'></div>
</body>
</html>

<script type='text/javascript' src="<?=site_url('js/jquery-1.5.1.min.js')?>">
</script>
<script>
	$(document).ready(function() {
		get('users');
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
