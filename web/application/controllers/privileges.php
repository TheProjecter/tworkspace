<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');

class Privileges extends CI_Controller 
{
	var $table = 'privilege';

	public function __construct()
	{
		parent::__construct();
		$this->load->library('session');
	}

	public function index()
	{
		$this->load->helper(array('form'));
		$this->load->view('privileges');
	}

	public function remove()
	{
		$this->load->database();
		$id = $this->input->get('id');
		$this->db->delete("tworkspace.".$this->table, array('id' => $id)); 
	}

	public function create()
	{
		$this->load->library('form_validation');

		$options = $this->input->post('create_options');
		$privilege = "000000";
		if(is_array($options)) {
			foreach($options as $key => $value) {
				switch ($key) {
					case 'watch_projects': 
						$privilege[0] = '1';
						break;
					case 'watch_users': 
						$privilege[1] = '1';
						break;
					case 'watch_privileges': 
						$privilege[2] = '1';
						break;
					case 'create_project': 
						$privilege[3] = '1';
						break;
					case 'create_user': 
						$privilege[4] = '1';
						break;
					case 'create_privilege': 
						$privilege[5] = '1';
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
			$this->load->view('privileges', $data);
		} else {
			$this->load->database();
			$this->load->model('tdatabase_model');
			$data = array(
					'name' => $this->input->post('create_name'),
					'description' => $this->input->post('create_description'),
					'code' => $privilege 
					);
			$this->tdatabase_model->insert_entry($data, 'name');
			redirect('privileges');	
		}
	}

	public function get()
	{
		$this->load->database();
		$this->load->model('tdatabase_model');
		$result = $this->tdatabase_model->get_entry();
		$this->load->library('table');
		foreach($result as $key=>$value) {
			if(empty($value)) continue;
			$name = "<a href='".site_url('/privileges/name/'.$value['name'])."'>".$value['name']."</a>";
			$rm = "<a href='javascript: void(0)' onClick=\"remove(".$value['id'].",'privileges');\">delete</a>";
			$this->table->add_row(array($name, $rm));
		}
		echo $this->table->generate();
	}

	public function name($name)
	{
		$this->load->database();
		$this->load->model('tdatabase_model');
		$result = $this->tdatabase_model->get_entry_where("name", $name);
		$data['privilege'] = $result[0];
		$this->load->view('privilege_individual.php', $data);
	}

}

?>
