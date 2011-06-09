<?php if (!defined('BASEPATH')) exit('No direct script access allowed');

require_once('phpass-0.1/PasswordHash.php');

define('PHPASS_HASH_STRENGTH', 8);
define('PHPASS_HASH_PORTABLE', false);

/**
 * SimpleLoginSecure Class
 *
 * Makes authentication simple and secure.
 *
 * Simplelogin expects the following database setup. If you are not using 
 * this setup you may need to do some tweaking.
 *   
 * 
 *   CREATE TABLE `users` (
 *     `id` int(10) unsigned NOT NULL auto_increment,
 *     `email` varchar(255) NOT NULL default '',
 *     `pass` varchar(60) NOT NULL default '',
 *     `date` datetime NOT NULL default '0000-00-00 00:00:00' COMMENT 'Creation date',
 *     `modified` datetime NOT NULL default '0000-00-00 00:00:00',
 *     `last_login` datetime NULL default NULL,
 *     PRIMARY KEY  (`id`),
 *     UNIQUE KEY `email` (`email`),
 *   ) ENGINE=InnoDB DEFAULT CHARSET=utf8;
 * 
 * @package   SimpleLoginSecure
 * @version   1.0.1
 * @author    Alex Dunae, Dialect <alex[at]dialect.ca>
 * @copyright Copyright (c) 2008, Alex Dunae
 * @license   http://www.gnu.org/licenses/gpl-3.0.txt
 * @link      http://dialect.ca/code/ci-simple-login-secure/
 */
class SimpleLoginSecure
{
	var $CI;
	var $table = 'users';

	/**
	 * Create a user account
	 *
	 * @access	public
	 * @param	string
	 * @param	string
	 * @param	bool
	 * @return	bool
	 */
	function create($email,
		$name,
		$pass,
		$project,
		$manager,
		$privilege,
		$photo,
		$auto_login = true) 
	{
		$this->CI =& get_instance();
		


		//Make sure account info was sent
		if($email == '' OR $pass == '') {
			return false;
		}
		
		//Check against user table
		$this->CI->db->where('email', $email); 
		$query = $this->CI->db->get_where($this->table);
		
		if ($query->num_rows() > 0) //email already exists
			return false;

		//Hash pass using phpass
		$hasher = new PasswordHash(PHPASS_HASH_STRENGTH, PHPASS_HASH_PORTABLE);
		$pass_hashed = $hasher->HashPassword($pass);

		//Insert account into the database
		$data = array(
					'email' => $email,
					'name' => $name, 
					'pass' => $pass_hashed,
					'project' => $project,
					'manager' => $manager,
					'privilege' => $privilege,
					'photo' => $photo,
					'date' => date('o-m-d H:i:s'),
					'modified' => date('o-m-d H:i:s'),
				);

		$this->CI->db->set($data); 

		if(!$this->CI->db->insert($this->table)) //There was a problem! 
			return false;						
				
		if($auto_login)
			$this->login($email, $pass);
		
		return true;
	}

	/**
	 * Login and sets session variables
	 *
	 * @access	public
	 * @param	string
	 * @param	string
	 * @return	bool
	 */
	function login($email = '', $pass = '') 
	{
		$this->CI =& get_instance();

		if($email == '' OR $pass == '')
			return false;


		//Check if already logged in
		if($this->CI->session->userdata('email') == $email)
			return true;
		
		
		//Check against user table
		$this->CI->db->where('email', $email); 
		$query = $this->CI->db->get_where($this->table);

		
		if ($query->num_rows() > 0) 
		{
			$data = $query->row_array(); 

			$hasher = new PasswordHash(PHPASS_HASH_STRENGTH, PHPASS_HASH_PORTABLE);

			if(!$hasher->CheckPassword($pass, $data['pass']))
				return false;

			//Destroy old session
			$this->CI->session->sess_destroy();
			
			//Create a fresh, brand new session
			$this->CI->session->sess_create();

			$this->CI->db->simple_query('UPDATE ' . $this->table  . ' SET last_login = NOW() WHERE id = ' . $data['id']);

			//Set session data
			unset($data['pass']);
			$data['user'] = $data['email']; // for compatibility with Simplelogin
			$data['logged_in'] = true;
			$this->CI->session->set_userdata($data);
			
			return true;
		} 
		else 
		{
			return false;
		}	

	}

	/**
	 * Logout user
	 *
	 * @access	public
	 * @return	void
	 */
	function logout() {
		$this->CI =& get_instance();		

		$this->CI->session->sess_destroy();
	}

	/**
	 * Delete user
	 *
	 * @access	public
	 * @param integer
	 * @return	bool
	 */
	function delete($id) 
	{
		$this->CI =& get_instance();
		
		if(!is_numeric($id))
			return false;			

		return $this->CI->db->delete($this->table, array('id' => $id));
	}
	
}
?>
