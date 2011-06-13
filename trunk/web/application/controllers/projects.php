<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');

class Projects extends CI_Controller 
{
	var $table = 'projects';

	public function __construct()
	{
		parent::__construct();
		$this->load->helper(array('form'));
		$this->load->library('session');
		if(! $this->session->userdata('logged_in')) {
			redirect('');
		}
	}

	public function index()
	{
		$this->load->view('projects.php');
	}

	private function is_valid_form()
	{
		$this->load->library('form_validation');
		
		//Check incoming variables
		$config = array(
			array(
				'field' => 'project_name',
				'label' => 'name',
				'rules' => "required|min_length[4]|max_length[50]|alpha_numeric"
			),
			array(
				'field' => 'project_desc',
				'label' => 'description',
				'rules' => "required|max_length[300]"
			),
			array(
				'field' => 'project_attachment_name',
				'label' => 'name',
				'rules' => "required|min_length[4]|max_length[50]|alpha_numeric"
			),
		);

		$this->form_validation->set_rules($config);
		return $this->form_validation->run();
	}

	private function get_input_data()
	{
			$data = array(
					'name' => $this->input->post('project_name'),
					'description' => $this->input->post('project_desc'),
					);
			return $data;
	}

	public function create()
	{
		$this->load->helper('url');

		if (! $this-> is_valid_form()) {
			$data['action'] = 'create';
			$this->load->view('projects.php', $data);
			echo "not ok";
		} else {
		/*
			$this->load->database();
			$this->load->model('tdatabase_model');
			$data = get_input_data();
			$this->tdatabase_model->insert_entry($data, 'name');
			redirect('projects');	
		*/
			echo "ok";
		}
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
		$this->load->model('tdatabase_model');
		$result = $this->tdatabase_model->get_entry();
		$this->load->library('table');
		foreach($result as $key=>$value) {
			if(empty($value)) continue;
			$p = "<a href='".site_url('/projects/name/'.$value['name'])."'>".$value['name']."</a>";
			$this->table->add_row(array($p));
		}
		echo $this->table->generate();
	}

	public function name($name)
	{
		$this->load->database();
		$this->load->model('tdatabase_model');
		$result = $this->tdatabase_model->get_entry_where("name", $name);
		$data['action'] = 'show';
		$data['project'] = $result[0];
		$this->load->view('projects_individual.php', $data);
	}

	public function update()
	{
		if ($this->is_valid_form()) {
			$data = get_input_data();	
			$data['id'] = $this->input->post('project_id');
		}
	}
}

/* End of file welcome.php */
/* Location: ./application/controllers/welcome.php */
