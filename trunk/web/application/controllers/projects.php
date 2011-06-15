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

	private function upload_attachments()
	{
		$config['upload_path'] = './uploads/';
		$config['allowed_types'] = 'pdf|doc|docx|odt';
		$config['max_size'] = '10000';
		$config['remove_spaces'] = TRUE;
		$config['overwrite'] = TRUE;
		$this->load->library('tupload', $config);
		return $this->tupload->do_upload_array('project_attachment');
	}

	public function create()
	{
		$this->load->helper('url');
		$data = array();
		if ($this-> is_valid_form()) {
			if ($this->upload_attachments()) {
				$this->load->database();
				$this->load->model('tdatabase_model');
				$data = $this->get_input_data();
				$data['attachments'] = join("|", $this->tupload->file_names); 
				$this->tdatabase_model->insert_entry($data, 'name');
				redirect('projects');	
			} else {
				$data['action'] = 'create';
				$data['error'] = 'some attached files either have no name or file is missed.';
			}
		} else {
				$data['action'] = 'create';
				$data['error'] = 'some fields are not filled properly.';
		}
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
		$data['project'] = $result[0];
		$this->load->view('projects_individual.php', $data);
	}

	public function update()
	{
		$id = $this->input->post('id');
		$this->load->database();
		$this->load->model('tdatabase_model');
		$result = $this->tdatabase_model->get_entry_where("id", $id);
		$data['project'] = $result[0];
		if ($this->is_valid_form()) {
			$input_data = $this->get_input_data();	
			$data['project']['description'] = $input_data['description'];
			$data['project']['name'] = $input_data['name'];
			$this->tdatabase_model->update_entry($data['project']);
		} else {
			$data['error'] = "some forms are not filled properly";
		}
		$this->load->view('projects_individual.php', $data);
	}

	public function get_attachments($name)
	{
		$this->load->database();
		$this->load->model('tdatabase_model');
		$result = $this->tdatabase_model->get_entry_where("name", $name);
		$project = $result[0];
		foreach(explode("|", $project['attachments']) as $a) {
			print("<a href='". site_url('/uploads/'.$a) ."'>$a</a>".
				  " (<a href='javascript: void(0);' ".
				  "onClick='remove_attachment(\"".$a."\")'>remove</a>)<br>"
					);
		}
	}

	public function remove_attachment($name, $id)
	{
		$this->load->database();
		$this->load->model('tdatabase_model');
		$result = $this->tdatabase_model->get_entry_where("name", $name);
		$data = $result[0];
		$rest_attachments = array();
		foreach(explode("|", $data['attachments']) as $a) {
			if($a != $id) array_push($rest_attachments, $a);
		}
		$data['attachments'] = join("|", $rest_attachments); 
		$this->tdatabase_model->update_entry($data);
		$this->get_attachments($name);
	}
}

/* End of file welcome.php */
/* Location: ./application/controllers/welcome.php */
