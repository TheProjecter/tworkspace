<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="utf-8">
	<title>Welcome to tworkspace</title>

<link rel="stylesheet" type="text/css" href="<?=site_url('css/basic.css')?>" />

</head>
<body>

	<a href="<?=site_url('install')?>">install</a>
	<h1>Welcome to tworkspace!</h1>
	<table>
	<tr><td><a href="<?=site_url('projects/adding')?>">add project</a></td></tr>
	<tr><td><a href="<?=site_url('users/adding')?>">add user</a></td></tr>
	<table>
	<h1>Projects</h1>
	<div id='projects'></div>
	<h1>Users</h1>
	<div id='users'></div> 
	<h1>Issues</h1>
	<div id='issues'>
		<ul>
		<li>sessions - simple login/logout mechanizm</li>	
		<li>users with different privileges</li>	
		<li>svn</li>	
		<li>build system</li>	
		<li>regression tests</li>	
		</ul>
	</div>
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