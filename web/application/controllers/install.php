<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');

class Install extends CI_Controller 
{
	private function create_privileges_table() 
	{
		echo "Creating privileges tabel ... ";
		$fields = array(
			'id' => array(
				'type' => 'INT',
				'constraint' => 5,
				'unsigned' => TRUE,
				'auto_increment' => TRUE,
				'null' => FALSE,
				),
                'name' => array(
					'type' => 'VARCHAR',
					'constraint' => '100',
				),
                'description' => array(
					'type' => 'TEXT',
					'null' => TRUE,
				),
                'privilege' => array(
					'type' => 'VARCHAR',
					'constraint' => '100',
				),
		);
		$this->dbforge->add_key('id', TRUE);
		$this->dbforge->add_field($fields);
		$this->dbforge->create_table('tworkspace.privilege', TRUE);
		echo "<font color=green>done</font><br>";
	}

	private function create_projects_table() 
	{
		echo "Creating projects tabel ... ";
		$fields = array(
			'id' => array(
				'type' => 'INT',
				'constraint' => 5,
				'unsigned' => TRUE,
				'auto_increment' => TRUE,
				'null' => FALSE,
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
		echo "<font color=green>done</font><br>";
	}

	private function create_users_table() 
	{
		echo "Creating users table ... ";
		$fields = array(
			'id' => array(
				'type' => 'INT',
				'constraint' => 5,
				'unsigned' => TRUE,
				'auto_increment' => TRUE,
				'null' => FALSE,
			),
			'email' => array(
				'type' => 'varchar',
				'constraint' => '255',
			),
			'name' => array(
				'type' => 'VARCHAR',
				'constraint' => '60'
			),
			'pass' => array(
				'type' => 'VARCHAR',
				'constraint' => '60',
			),
			'project' => array(
				'type' => 'INT',
				'constraint' => '5',
				'unsigned' => 'TRUE',
			),
			'manager' => array(
				'type' => 'INT',
				'constraint' => '5',
				'unsigned' => 'TRUE',
			),
			'privilege' => array(
				'type' => 'INT',
				'constraint' => '5',
				'unsigned' => 'TRUE',
			),
			'photo' => array(
				'type' => 'VARCHAR',
				'constraint' => '60',
			),
			'date' => array(
				'type' => 'VARCHAR',
				'constraint' => '60',
			),
			'modified' => array(
				'type' => 'VARCHAR',
				'constraint' => '60',
			),
			'last_login' => array(
				'type' => 'VARCHAR',
				'constraint' => '60',
			),
		);
		$this->dbforge->add_key('id', TRUE);
		$this->dbforge->add_field($fields);
		$this->dbforge->create_table('tworkspace.users', TRUE);
		echo "<font color=green>done</font><br>";
	}

	private function create_actions_table() 
	{
		echo "Creating actions table ... ";
		$fields = array(
			'id' => array(
				'type' => 'INT',
				'constraint' => 5,
				'unsigned' => TRUE,
				'auto_increment' => TRUE,
				'null' => FALSE,
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
		echo "<font color=green>done</font><br>";
	}

	private function create_tables()
	{
		$this->create_privileges_table();
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
		$this->load->dbforge();
		$this->load->dbutil();
		$this->create_database();
		$this->load->database();
		$this->create_tables();
		$this->load->view('install.php');
	}

	public function __construct()
	{
		parent::__construct();
	}
}

/* End of file install.php */
/* Location: ./application/controllers/install.php */
