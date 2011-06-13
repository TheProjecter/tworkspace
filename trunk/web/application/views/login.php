<html>
<head>
<link rel="stylesheet" type="text/css" href="<?=site_url('css/basic.css')?>" />
</head>

<body>
	<div id='login'>
		<h1>Login</h1>
		<div class='form_container'>	
			<?=form_open('login')?>
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
</body>
</html>
