<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');

class Privilege extends CI_Controller 
{
	var $table = 'privilege';

	public function __construct()
	{
		parent::__construct();
	}

	public function index()
	{
		$this->load->helper(array('form'));
		$this->load->view('privilege');
	}

	public function create()
	{
		$this->load->library('form_validation');

		$options = $this->input->post('create_options');
		$privilege = "000";
		if(is_array($options)) {
			foreach($options as $key => $value) {
				switch ($key) {
					case 'create_project': 
						$privilege[0] = '1';
						break;
					case 'create_user': 
						$privilege[1] = '1';
						break;
					case 'create_privilege': 
						$privilege[2] = '1';
						break;
				}
			}
		}

		//Check incoming variables
		$config = array(
			array(
				'field' => 'create_name',
				'label' => 'Name',
				'rules' => "required|min_length[4]|max_length[50]|alpha_numeric"
			),
			array(
				'field' => 'create_description',
				'label' => 'Description',
				'rules' => "required|max_length[300]"
			),
		);

		$this->form_validation->set_rules($config);

		if ($this->form_validation->run() == false) {
			$data['action'] = 'create';
			$this->load->view('privilege.php', $data);
		} else {
			$this->load->database();
			$this->load->model('tdatabase_model');
			$data = array(
					'name' => $this->input->post('create_name'),
					'description' => $this->input->post('create_description'),
					'privilege' => $privilege 
					);
			$this->tdatabase_model->insert_entry($data, 'name');
			redirect('privilege');	
		}
	}

	public function get()
	{
		$this->load->database();
		$this->load->model('tdatabase_model');
		$result = $this->tdatabase_model->get_entry();
		$this->load->library('table');
		$this->table->set_heading(array_keys($result[0]));
		foreach($result as $key=>$value) {
			$this->table->add_row(array_values($value));
		}
		echo $this->table->generate();
	}

}

?>
