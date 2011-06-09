<html>
<head>
<link rel="stylesheet" type="text/css" href="<?=site_url('css/basic.css')?>" />
</head>

<body>
	
	<table>
	<tr><td><a href="<?=site_url('')?>">home</a></td></tr>
	<tr><td><a href="<?=site_url('projects/create')?>">create project</a></td></tr>
	<tr><td><a href="<?=site_url('privilege/create')?>">create_privilege</a></td></tr>
	<table>
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
	<div id='login'>
		<h1>Login</h1>
		<div class='form_container'>	
			<?=form_open('users/login')?>
				<?=form_fieldset('User login form')?>
				<div class='textfield'>
					<?=form_label('Email', 'login_email')?>
					<?=form_input('login_email');?>
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

	<div id="show">
		<h1><?=$user_name?></h1>
		<img src=<?=site_url("/uploads/$user_photo")?>/>
	</div>

	<h1>all users</h1>
	<div id='users'></div>
	<a href="<?=site_url('')?>">back</a>
</body>
</html>

<script type='text/javascript' src="<?=site_url('js/jquery-1.5.1.min.js')?>">
</script>
<script>
	$(document).ready(function() {
		get('users');
<?php 
	if(!isset($action) or $action != "create") {
		echo "$('#create').hide();";
	}
?>
<?php 
	if(!isset($action) or $action != "login") {
		echo "$('#login').hide();";
	}
?>
<?php 
	if(!isset($action) or $action != "show") {
		echo "$('#show').hide();";
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
