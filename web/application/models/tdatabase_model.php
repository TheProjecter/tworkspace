<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');

class tdatabase_model extends CI_Model {

	var $CI;

	function __constructor()
	{
		parent::__constructor();
	}

	function insert_entry($data, $entry="")
	{
		$this->CI =& get_instance();

		if(! empty($entry)) {
			$this->CI->db->where($entry, $data[$entry]); 
			$query = $this->CI->db->get_where($this->CI->table);
			if ($query->num_rows() > 0) {
				return false;
			}
		}
		
		$this->CI->db->set($data); 

		if(!$this->CI->db->insert($this->CI->table)) {
			return false;						
		}
	} 

	function update_entry()
	{
	}

	function remove_entry()
	{
	}

	function get_entry($entry="", $value="")
	{
		$this->CI =& get_instance();

		if(!empty($entry)) {
			$this->CI->db->where($entry, $value); 
			$query = $this->CI->db->get_where($this->CI->table);
			
			if ($query->num_rows() == 0) {
				return false;
			}
		} else {
			$query = $this->CI->db->get($this->CI->table);
		}
		$result_array[0] = $query->first_row('array');
		for($i = 1; $i < $query->num_rows(); $i++) {
			$result_array[$i] = $query->next_row('array');
		}
		$query->free_result();
		return $result_array;
	}

}

?>
