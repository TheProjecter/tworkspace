<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');

class Install extends CI_Controller 
{
	private function create_projects_table() 
	{
		$fields = array(
			'id' => array(
				'type' => 'INT',
				'constraint' => 5,
				'unsigned' => TRUE,
				'auto_increment' => TRUE
				),
                'name' => array(
					'type' => 'VARCHAR',
					'constraint' => '100',
				),
                'description' => array(
					'type' => 'TEXT',
					'null' => TRUE,
				),
		);
		$this->dbforge->add_key('id', TRUE);
		$this->dbforge->add_field($fields);
		$this->dbforge->create_table('tworkspace.projects', TRUE);
	}

	private function create_users_table() 
	{
		$fields = array(
			'id' => array(
				'type' => 'INT',
				'constraint' => 5,
				'unsigned' => TRUE,
				'auto_increment' => TRUE
			),
            'name' => array(
				'type' => 'VARCHAR',
				'constraint' => '100',
			),
            'password' => array(
				'type' => 'VARCHAR',
				'constraint' => '100',
			),
		);
		$this->dbforge->add_key('id', TRUE);
		$this->dbforge->add_field($fields);
		$this->dbforge->create_table('tworkspace.users', TRUE);
	}

	private function create_actions_table() 
	{
		$fields = array(
			'id' => array(
				'type' => 'INT',
				'constraint' => 5,
				'unsigned' => TRUE,
				'auto_increment' => TRUE
			),
			'uid' => array(
				'type' => 'INT',
				'constraint' => 5,
				'unsigned' => TRUE,
			),
            'action' => array(
				'type' => 'VARCHAR',
				'constraint' => '100',
			),
            'comment' => array(
				'type' => 'VARCHAR',
				'constraint' => '100',
			),
		);
		$this->dbforge->add_key('id', TRUE);
		$this->dbforge->add_field($fields);
		$this->dbforge->create_table('tworkspace.actions', TRUE);
	}

	private function create_tables()
	{
		$this->create_projects_table();	
		$this->create_users_table();	
		$this->create_actions_table();	
	}

	private function create_database()
	{
		if (! $this->dbutil->database_exists("tworkspace")) {
			$this->dbforge->create_database("tworkspace");
		}
	}

	public function index()
	{
		$this->load->view('install.php');
		$this->load->database();
		$this->load->dbforge();
		$this->load->dbutil();
		$this->create_database();
		$this->create_tables();
	}

	public function __construct()
	{
		parent::__construct();
	}
}

/* End of file install.php */
/* Location: ./application/controllers/install.php */
