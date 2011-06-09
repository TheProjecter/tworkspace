<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');

class Users extends CI_Controller 
{
	var $table = 'users';

	private function upload($name)
	{
		$config['upload_path'] = './uploads/';
		$config['allowed_types'] = 'gif|jpg|png';
		$config['max_size'] = '100';
		$config['max_width'] = '1024';
		$config['max_height'] = '768';
		$config['file_name'] = $name;
		$config['remove_spaces'] = TRUE;
		$config['overwrite'] = TRUE;

		$this->load->library('upload', $config);
		if (! $this->upload->do_upload('create_photo')) {
			$data['message'] = $this->upload->display_errors();
			$this->load->view('users', $data);
			return 0;
		}	
		return 1;
	}

	public function create()
	{
		//Load
		$this->load->helper('url');
		$this->load->library('form_validation');
		
		//Check incoming variables
		$config = array(
			array(
				'field' => 'create_email',
				'label' => 'email',
				'rules' => "required|valid_email"
			),
			array(
				'field' => 'create_username',
				'label' => 'username',
				'rules' => "required|min_length[4]|max_length[32]"
			),
			array(
				'field' => 'create_password',
				'label' => 'password',
				'rules' => "required|min_length[4]|max_length[32]"
			),
			array(
				'field' => 'create_project',
				'label' => 'project',
				'rules' => "required|is_natural",
			),
			array(
				'field' => 'create_manager',
				'label' => 'manager',
				'rules' => "required|is_natural"
			),
			array(
				'field' => 'create_privilege',
				'label' => 'privilege',
				'rules' => "required|is_natural"
			),
		);

		$this->form_validation->set_rules($config);

		if ($this->form_validation->run() == false) {
			/*redirect('/users/login');*/
			$data['action'] = 'create';
			$data['privilege'] = $this->get_privileges();
			$data['managers'] = $this->get_managers();
			$data['projects'] = $this->get_projects();
			$data['message'] = validation_errors();
			$this->load->view('users.php', $data);
		} else {
			//Create account
			if(! $this->upload($this->input->post('create_username'))) {
				return;
			}
			$upload_data = $this->upload->data();
			if ($this->simpleloginsecure->create($this->input->post('create_email'), 
								$this->input->post('create_username'),
								$this->input->post('create_password'),
								$this->input->post('create_project'),
								$this->input->post('create_manager'),
								$this->input->post('create_privilege'),
								$upload_data['file_name']
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
		$result[0] = "root";
		$query = $this->tdatabase_model->get_entry();
		foreach($query as $row) {
			if(empty($row)) continue;
			$result[$row['id']] = $row['name'] . "  " . $row['email'];
		}
		return $result;
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
		$this->load->model('tdatabase_model');
		$result = $this->tdatabase_model->get_entry();
		$this->load->library('table');
		$table_heading = array();
		$table_rows = array();
		foreach ($result as $user) {
			$arow = array();
			foreach ($user as $prop=>$val) {
				if($prop == "pass") continue;
				if($prop == "photo") {
					$val = "<a href=".site_url("/uploads/$val").">$val</a>";
				}
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


	public function login()
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

	public function name($name)
	{
		$this->load->database();
		$this->load->model('tdatabase_model');
		$result = $this->tdatabase_model->get_entry_where("name", $name);
		$data['action'] = 'show';
		$data['user_name'] = $result[0]['name'];
		$data['user_photo'] = $result[0]['photo'];
		$this->load->view('users.php', $data);
	}

	public function index()
	{
		$this->load->helper(array('form'));
		$this->load->view('users.php');

		//Load the URL helper
		$this->load->helper('url');
		
		//BOF Status Info
		echo '<div id="status">';
			echo '<h3>User Status</h3>';
			if($this->session->userdata('logged_in')) {
				echo 'User logged in as ' . $this->session->userdata('email');
			} else {
				echo 'User not logged in';
			}
		echo '</div>';
		echo '<hr />';
		//EOF Status Info
	}

	public function logout()
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
