<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');

class Users extends CI_Controller 
{
	var $table = 'users';

	function create()
	{
		//Load
		$this->load->helper('url');
		$this->load->library('form_validation');
		
		//Check incoming variables
		$config = array(
			array(
				'field' => 'create_email',
				'label' => 'Username',
				'rules' => "required|valid_email"
			),
			array(
				'field' => 'create_username',
				'label' => 'Username',
				'rules' => "required|min_length[4]|max_length[32]"
			),
			array(
				'field' => 'create_password',
				'label' => 'Password',
				'rules' => "required|min_length[4]|max_length[32]"
			),
			array(
				'field' => 'create_project',
				'label' => 'Project',
				'rules' => "required|is_natural",
			),
			array(
				'field' => 'create_manager',
				'label' => 'Manager',
				'rules' => "required|is_natural"
			),
			array(
				'field' => 'create_privilege',
				'label' => 'Privilege',
				'rules' => "required|is_natural"
			),
			array(
				'field' => 'create_photo',
				'label' => 'Photo',
				'rules' => "required|min_length[1]|max_length[50]"
			),
		);

		$this->form_validation->set_rules($config);

		if ($this->form_validation->run() == false) {
			/*redirect('/users/login');*/
			$data['action'] = 'create';
			$data['privilege'] = $this->get_privileges();
			$data['managers'] = $this->get_managers();
			$data['projects'] = $this->get_projects();
			$this->load->view('users.php', $data);
		} else {
			//Create account
			if ($this->simpleloginsecure->create($this->input->post('create_email'), 
								$this->input->post('create_username'),
								$this->input->post('create_password'),
								$this->input->post('create_project'),
								$this->input->post('create_manager'),
								$this->input->post('create_privilege'),
								$this->input->post('create_photo')
							) ) 
			{
				redirect('');	
			} else {
				redirect('/users/create');			
			}
		}
	}

	private function get_projects()
	{
		$this->load->database();
		$this->load->model('tdatabase_model');
		$result = array();
		$query = $this->tdatabase_model->get_entry('projects');
		foreach($query as $row) {
			if(empty($row)) continue;
			$result[$row['id']] = $row['name'];
		}
		return $result;
	}

	private function get_privileges()
	{
		$this->load->database();
		$this->load->model('tdatabase_model');
		$result = array();
		$query = $this->tdatabase_model->get_entry('privilege');
		foreach($query as $row) {
			if(empty($row)) continue;
			$result[$row['id']] = $row['name'];
		}
		return $result;
	}

	private function get_managers()
	{
		$this->load->database();
		$this->load->model('tdatabase_model');
		$result = array();
		$query = $this->tdatabase_model->get_entry();
		foreach($query as $row) {
			if(empty($row)) continue;
			$result[$row['user_id']] = $row['user_name'] . "  " . $row['user_email'];
		}
		return $result;
	}

	public function remove()
	{
		$this->load->database();
		$id = $this->input->get('id');
		$this->db->delete('tworkspace.users', array('user_id' => $id)); 
	}

	public function get()
	{
		$this->load->database();
		$this->load->model('tdatabase_model');
		$result = $this->tdatabase_model->get_entry();
		$this->load->library('table');
		$table_heading = array();
		$table_rows = array();
		foreach ($result as $user) {
			$arow = array();
			foreach ($user as $prop=>$val) {
				if($prop == "user_pass") continue;
				$table_heading[$prop] = 1;
				array_push($arow, $val);
			}
			array_push($table_rows, $arow);
		}
		$this->table->set_heading(array_keys($table_heading));
		foreach($table_rows as $arow) {
			$this->table->add_row($arow);
		}
		echo $this->table->generate();
	}


	function login()
	{
		//Load
		$this->load->helper('url');
		$this->load->library('form_validation');
		
		//Check incoming variables
		$config = array(
			array(
				'field' => 'login_email',
				'label' => 'Username',
				'rules' => "required|valid_email"
			),
			array(
				'field' => 'login_password',
				'label' => 'Password',
				'rules' => "required|min_length[4]|max_length[32]"
			),
		);

		$this->form_validation->set_rules($config);
				
		if ($this->form_validation->run() == false) {
			$data['action'] = 'login';
			$this->load->view('users.php', $data);
		} else {
			if($this->simpleloginsecure->login($this->input->post('login_email'), 
			$this->input->post('login_password'))) 
			{
				redirect('');	
			} else {
				redirect('/users/login');			
			}			
		}
	}

	public function index()
	{
		$this->load->helper(array('form'));
		$this->load->view('users.php');

		//This assumes you used the sample MySQL table
		$user_table = 'users';
		
		//Load the URL helper
		$this->load->helper('url');
		
		//BOF Status Info
		echo '<div id="status">';
			echo '<h3>User Status</h3>';
			if($this->session->userdata('logged_in')) {
				echo 'User logged in as ' . $this->session->userdata('user_email');
			} else {
				echo 'User not logged in';
			}
		echo '</div>';
		echo '<hr />';
		//EOF Status Info
	}

	function logout()
	{
		//Load
		$this->load->helper('url');

		//Logout
		$this->simpleloginsecure->logout();
		redirect('');
	}

	public function __construct()
	{
		parent::__construct();
		$this->load->helper(array('form'));
		$this->load->library('SimpleLoginSecure');
		$this->load->library('session');
		$this->load->database();
	}
}

/* End of file welcome.php */
/* Location: ./application/controllers/users.php */
