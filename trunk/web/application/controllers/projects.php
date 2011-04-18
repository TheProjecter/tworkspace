<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');

class Projects extends CI_Controller 
{
	public function add()
	{
		$this->load->database();
		$name = $this->input->post('project_name');
		$description = $this->input->post('project_desc');
		$name = trim($name);
		$data['message'] = '';
		if(! empty($name)) {
			$this->db->select('name', FALSE);
			$this->db->from('tworkspace.projects');
			$this->db->where('name', $name);
			$result = $this->db->get();
			if (! $result->num_rows()) {
				$data['message'] = "<b>added</b><br>"
					."name: $name<BR>description: $description<BR>";
				$d = array(
						'name' => $name,
						'description' => $description,
						);
				$this->db->insert('tworkspace.projects', $d);
			} else {
				$data['message'] = "Another project with the name ".
					"<i>$name</i>".
					" already exists in the database.";
			}
		}
		$this->load->view('projects.php', $data);
	}

	public function adding()
	{
		$data['action'] = 'adding';
		$this->load->view('projects.php', $data);
	}

	public function remove()
	{
		$id = $this->input->get('id');
		$this->load->database();
		$this->db->delete('tworkspace.projects', array('id' => $id)); 
	}

	public function get()
	{
		$this->load->database();
		$this->db->select('id,name,description', FALSE);
		$this->db->from('tworkspace.projects');
		$query = $this->db->get();
		foreach ($query->result() as $row) {
			echo "<table><tr><td>".$row->id."</td>".
				"<td>".$row->name."</td>".
				"<td>".$row->description."</td>".
				"<td><input type='button' value='remove' ".
				"onclick='remove(".$row->id.',"projects")\'>'.
				"</input></td>".
				"</tr></table>";
		}
	}

	public function index()
	{
		$this->load->view('projects.php');
	}

	public function __construct()
	{
		parent::__construct();
		$this->load->helper(array('form'));
	}
}

/* End of file welcome.php */
/* Location: ./application/controllers/welcome.php */
