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
			<?=form_open('users/create')?>
				<?=form_fieldset('User adding form')?>
				<div class='textfield'>
					<?=form_label('Username', 'create_username')?>
					<?=form_input('create_username');?>
				</div>
				<div class='textfield'>
					<?=form_label('Password', 'create_password')?>
					<?=form_password('create_password')?>
				</div>
				<div class='buttons'>
					<?=form_submit('create', 'Create')?>
				</div>
			<?=form_close();?>
		</div>
	</div>
	<div id='login'>
		<h1>Login</h1>
		<div class='form_container'>	
			<?=form_open('users/login')?>
				<?=form_fieldset('User login form')?>
				<div class='textfield'>
					<?=form_label('Username', 'login_username')?>
					<?=form_input('login_username');?>
				</div>
				<div class='textfield'>
					<?=form_label('Password', 'login_password')?>
					<?=form_password('login_password')?>
				</div>
				<div class='buttons'>
					<?=form_submit('login', 'Login')?>
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
<?php 
	if(!isset($action) or $action != "adding") {
		echo "$('#adding').hide();";
	}
?>
<?php 
	if(!isset($action) or $action != "login") {
		echo "$('#login').hide();";
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
