<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');

class Login extends CI_Controller 
{
	public function __construct()
	{
		parent::__construct();
		$this->load->library('SimpleLoginSecure');
		$this->load->library('session');
		$this->load->database();
	}

	public function index()
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
			$this->load->view('login');
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
}
