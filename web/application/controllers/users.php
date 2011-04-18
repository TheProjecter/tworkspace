<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');

class Users extends CI_Controller {

	public function add()
	{
		$this->load->database();
		$name = $this->input->post('user_name');
		$password = $this->input->post('user_pass');
		$name = trim($name);
		$data['message'] = '';
		if(! empty($name)) {
			$this->db->select('name', FALSE);
			$this->db->from('tworkspace.users');
			$this->db->where('name', $name);
			$this->db->where('password', $password);
			$result = $this->db->get();
			if (! $result->num_rows()) {
				$data['message'] = "<b>added</b><br>"
					."name: $name<BR>password: $password<BR>";
				$d = array(
						'name' => $name,
						'password' => $password,
						);
				$this->db->insert('tworkspace.users', $d);
			} else {
				$data['message'] = "Another user with the name ".
					"<i>$name</i>".
					" already exists in the database.";
			}
		}
		$this->load->view('users.php', $data);
	}

	public function adding()
	{
		$data['action'] = 'adding';
		$this->load->view('users.php', $data);
	}

	public function remove()
	{
		$this->load->database();
		$id = $this->input->get('id');
		$this->db->delete('tworkspace.users', array('id' => $id)); 
	}

	public function get()
	{
		$this->load->database();
		$this->db->select('id,name,password', FALSE);
		$this->db->from('tworkspace.users');
		$query = $this->db->get();
		foreach ($query->result() as $row) {
			echo "<table><tr><td>".$row->id."</td>".
				"<td>".$row->name."</td>".
				"<td>".$row->password."</td>".
				"<td><input type='button' value='remove' ".
				"onclick='remove(".$row->id.',"users")\'>'.
				"</input></td>".
				"</tr></table>";
		}
	}

	public function index()
	{
		$this->load->helper(array('form'));
		$this->load->view('users.php');
	}

	public function __construct()
	{
		parent::__construct();
		$this->load->helper(array('form'));
	}
}

/* End of file welcome.php */
/* Location: ./application/controllers/welcome.php */
