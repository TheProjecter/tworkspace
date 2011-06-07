<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');

class Users extends CI_Controller {

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
				'rules' => "required|min_length[4]|max_length[12]"
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
			$data['action'] = 'adding';
			$this->load->view('users.php', $data);
		} else {
			//Create account

			if($this->simpleloginsecure->create($this->input->post('create_email'), 
								$this->input->post('create_username'),
								$this->input->post('create_password'),
								$this->input->post('create_project'),
								$this->input->post('create_manager'),
								$this->input->post('create_privilege'),
								$this->input->post('create_photo')
							)) 
			{
				redirect('');	
			} else {
				redirect('/users/create');			
			}
		}
	}

	public function remove()
	{
		$this->load->database();
		$id = $this->input->get('id');
		$this->db->delete('tworkspace.users', array('user_id' => $id)); 
	}

	public function get()
	{
		$this->load->helper('date');
		$this->load->database();
		$this->db->select('user_id,user_email,user_name,user_project,user_manager,user_privilege,user_photo,user_date,user_modified,user_last_login', FALSE);
		$this->db->from('tworkspace.users');
		$query = $this->db->get();
		echo "<table>";
		foreach ($query->result() as $row) {
			echo "<tr><td>".$row->user_id."</td>".
				"<td>".$row->user_email."</td>".
				"<td>".$row->user_name."</td>".
				"<td>".$row->user_project."</td>".
				"<td>".$row->user_manager."</td>".
				"<td>".$row->user_privilege."</td>".
				"<td>".$row->user_photo."</td>".
				"<td>".$row->user_date."</td>".
				"<td>".$row->user_modified."</td>".
				"<td>".$row->user_last_login."</td>".
				"<td><input type='button' value='remove' ".
				"onclick='remove(".$row->user_id.',"users")\'>'.
				"</input></td>".
				"</tr>";
		}
		echo "</table>";
	}


	function login()
	{
		//Load
		$this->load->helper('url');
		$this->load->library('form_validation');
		
		//Check incoming variables
		$config = array(
			array(
				'field' => 'login_username',
				'label' => 'Username',
				'rules' => "required|min_length[4]|max_length[32]|alpha_dash"
			),
			array(
				'field' => 'login_password',
				'label' => 'Password',
				'rules' => "required|min_length[4]|max_length[32]|alpha_dash"
			),
		);

		$this->form_validation->set_rules($config);
				
		if ($this->form_validation->run() == false) {
			/*
			//If you are using OBSession you can uncomment these lines
			$flashdata = array('error' => true, 'error_text' => $this->form_validation->error_string);
			$this->session->set_flashdata($flashdata); 
			$this->session->set_flashdata($_POST);
			*/
			//redirect('/users/login/');			
			$data['action'] = 'login';
			$this->load->view('users.php', $data);
		} else {
			//Create account
			if($this->simpleloginsecure->login($this->input->post('login_username'), $this->input->post('login_password'))) {
				/*
				//If you are using OBSession you can uncomment these lines
				$flashdata = array('success' => true, 'success_text' => 'Login Successful!');
				$this->session->set_flashdata($flashdata);
				*/
				redirect('');	
			} else {
				/*
				//If you are using OBSession you can uncomment these lines
				$flashdata = array('error' => true, 'error_text' => 'There was a problem logging into the account.');
				$this->session->set_flashdata($flashdata); 
				$this->session->set_flashdata($_POST);
				*/
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

		//BOF User table
		if($this->session->userdata('logged_in')) {
			//Grab user data from database
			$query = $this->db->select('user_id, user_email');
			$query = $this->db->get($user_table);
			$user_array = $query->result_array();
			
			if(count($user_array) > 0) {
				echo '<div id="user_table">';
					echo '<h3>User Table</h3>';
					echo '<table>';
						echo '<tr>';
							echo '<th>';
								echo 'ID';
							echo '</th>';
							echo '<th>';
								echo 'Username';
							echo '</th>';
							echo '<th>';
								echo 'Delete';
							echo '</th>';
						echo '</tr>';
						foreach($user_array as $ua) {
							echo '<tr>';
								echo '<td>';
									echo $ua['user_id'];
								echo '</td>';
								echo '<td>';
									echo $ua['user_email'];
								echo '</td>';
								echo '<td>';
									echo '<a href="' . site_url('/example/delete/' . $ua['user_id']) . '" onclick="return confirm(\'Are you sure you want to delete this user?\')">Delete</a>';
								echo '</td>';
							echo '</tr>';
						}
					echo '</table>';
				echo '</div>';
				echo '<hr />';
			}
		}
		//EOF User table
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
/* Location: ./application/controllers/welcome.php */
