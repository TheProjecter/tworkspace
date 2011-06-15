
<script>
	function add_attachment()
	{
		i=$('#n_attachments').val();
		html=$('#attachments').html();
		form='<div id="f'+i+'" class="textfield">' +
			'<label id="l1'+i+'" for="project_attachment_name[' + i + ']">name</label>' +
			'<input id="t1'+i+'" type="text" name="project_attachment_name[' + i + ']" /><br>' + 
			'<label id="l2'+i+'" for="project_attachment[' + i + ']">file</label>' +
			'<input id="t2'+i+'" type="file" name="project_attachment[' + i + ']"<br>' + 
			'<button id="b'+i+'" onClick=delete_attachment(' + i + ')>delete</button>' +
			'</div>';
		$('#attachments').html(html+form);
		$('#n_attachments').val(++i);
	}

	function get_attachments(s)
	{
		$.ajax({
		  url: "<?=site_url('/projects/get_attachments/')?>/"+s,
		  data: "",
		  success: function(data){
			$('#attachments').html(data);
		  }
		});
	}

	function remove_attachment(i,s)
	{
		$.ajax({
		  url: "<?=site_url('/projects/remove_attachment/')?>/"+s+"/"+i,
		  data: "",
		  success: function(data){
			$('#attachments').html(data);
		  }
		});
	}

	function delete_attachment(i)
	{
		$("#t1"+i).remove();
		$("#l1"+i).remove();
		$("#l2"+i).remove();
		$("#t2"+i).remove();
		$("#b"+i).remove();
		$("#f"+i).remove();
		html=$('#attachments').html();
		$('#attachments').html(html);
	}
</script>
