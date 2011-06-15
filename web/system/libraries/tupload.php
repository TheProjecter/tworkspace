<?php  if ( ! defined('BASEPATH')) exit('No direct script access allowed');

require('Upload.php');
/**
 * CodeIgniter
 *
 * An open source application development framework for PHP 5.1.6 or newer
 *
 * @package		CodeIgniter
 * @author		ExpressionEngine Dev Team
 * @copyright	Copyright (c) 2008 - 2011, EllisLab, Inc.
 * @license		http://codeigniter.com/user_guide/license.html
 * @link		http://codeigniter.com
 * @since		Version 1.0
 * @filesource
 */

// ------------------------------------------------------------------------

/**
 * File Uploading Class
 *
 * @package		CodeIgniter
 * @subpackage	Libraries
 * @category	tuploads
 * @author		ExpressionEngine Dev Team
 * @link		http://codeigniter.com/user_guide/libraries/file_uploading.html
 */
class CI_tupload extends CI_Upload {

	var $file_names = array();

	/**
	 * Perform the file upload
	 *
	 * @return	bool
	 */
	public function do_upload_array($field = 'userfile')
	{
		foreach ($_FILES[$field]['tmp_name'] as $key => $tmp_name) {
		// Are $_FILES[$field] set? If not, no reason to continue.
		if ( ! isset($_FILES[$field]))
		{
			$this->set_error('upload_no_file_selected');
			return FALSE;
		}

		// Are the upload path valid?
		if ( ! $this->validate_upload_path())
		{
			// errors will already be set by validate_upload_path() so just return FALSE
			return FALSE;
		}

		// Was the file able to be uploaded? If not, determine the reason why.
		if ( ! is_uploaded_file($_FILES[$field]['tmp_name'][$key]))
		{
			$error = ( ! isset($_FILES[$field]['error'][$key])) ? 4 : $_FILES[$field]['error'][$key];

			switch($error)
			{
				case 1:	// UPLOAD_ERR_INI_SIZE
					$this->set_error('upload_file_exceeds_limit');
					break;
				case 2: // UPLOAD_ERR_FORM_SIZE
					$this->set_error('upload_file_exceeds_form_limit');
					break;
				case 3: // UPLOAD_ERR_PARTIAL
					$this->set_error('upload_file_partial');
					break;
				case 4: // UPLOAD_ERR_NO_FILE
					$this->set_error('upload_no_file_selected');
					break;
				case 6: // UPLOAD_ERR_NO_TMP_DIR
					$this->set_error('upload_no_temp_directory');
					break;
				case 7: // UPLOAD_ERR_CANT_WRITE
					$this->set_error('upload_unable_to_write_file');
					break;
				case 8: // UPLOAD_ERR_EXTENSION
					$this->set_error('upload_stopped_by_extension');
					break;
				default :   $this->set_error('upload_no_file_selected');
					break;
			}

			return FALSE;
		}


		// Set the uploaded data as class variables
		$this->file_temp = $_FILES[$field]['tmp_name'][$key];
		$this->file_size = $_FILES[$field]['size'][$key];
		$this->file_type = preg_replace("/^(.+?);.*$/", "\\1", $_FILES[$field]['type'][$key]);
		$this->file_type = strtolower(trim(stripslashes($this->file_type), '"'));
		$file_name = $this->_prep_filename($_FILES[$field]['name'][$key]);
		$this->file_ext	 = $this->get_extension($file_name);
		$this->client_name = $file_name;

		// Is the file type allowed to be uploaded?
		if ( ! $this->is_allowed_filetype($key, FALSE))
		{
			$this->set_error('upload_invalid_filetype');
			return FALSE;
		}

		// if we're overriding, let's now make sure the new name and type is allowed
		if ($this->_file_name_override != '')
		{
			$file_name = $this->_prep_filename($this->_file_name_override);

			// If no extension was provided in the file_name config item, use the uploaded one
			if (strpos($this->_file_name_override, '.') === FALSE)
			{
				$file_name .= $this->file_ext;
			}

			// An extension was provided, lets have it!
			else
			{
				$this->file_ext	 = $this->get_extension($this->_file_name_override);
			}

			if ( ! $this->is_allowed_filetype(TRUE))
			{
				$this->set_error('upload_invalid_filetype');
				return FALSE;
			}
		}

		// Convert the file size to kilobytes
		if ($this->file_size > 0)
		{
			$this->file_size = round($this->file_size/1024, 2);
		}

		// Is the file size within the allowed maximum?
		if ( ! $this->is_allowed_filesize())
		{
			$this->set_error('upload_invalid_filesize');
			return FALSE;
		}

		// Are the image dimensions within the allowed size?
		// Note: This can fail if the server has an open_basdir restriction.
		if ( ! $this->is_allowed_dimensions())
		{
			$this->set_error('upload_invalid_dimensions');
			return FALSE;
		}

		// Sanitize the file name for security
		$file_name = $this->clean_file_name($file_name);

		// Truncate the file name if it's too long
		if ($this->max_filename > 0)
		{
			$file_name = $this->limit_filename_length($file_name, $this->max_filename);
		}

		// Remove white spaces in the name
		if ($this->remove_spaces == TRUE)
		{
			$file_name = preg_replace("/\s+/", "_", $file_name);
		}

		/*
		 * Validate the file name
		 * This function appends an number onto the end of
		 * the file if one with the same name already exists.
		 * If it returns false there was a problem.
		 */
		$this->orig_name = $file_name;

		if ($this->overwrite == FALSE)
		{
			$file_name = $this->set_filename($this->upload_path, $file_name);

			if ($file_name === FALSE)
			{
				return FALSE;
			}
		}

		/*
		 * Run the file through the XSS hacking filter
		 * This helps prevent malicious code from being
		 * embedded within a file.  Scripts can easily
		 * be disguised as images or other file types.
		 */
		if ($this->xss_clean)
		{
			if ($this->do_xss_clean() === FALSE)
			{
				$this->set_error('upload_unable_to_write_file');
				return FALSE;
			}
		}

		/*
		 * Move the file to the final destination
		 * To deal with different server configurations
		 * we'll attempt to use copy() first.  If that fails
		 * we'll use move_uploaded_file().  One of the two should
		 * reliably work in most environments
		 */
		if ( ! @copy($this->file_temp, $this->upload_path.$file_name))
		{
			if ( ! @move_uploaded_file($this->file_temp, $this->upload_path.$file_name))
			{
				$this->set_error('upload_destination_error');
				return FALSE;
			}
		}

		/*
		 * Set the finalized image dimensions
		 * This sets the image width/height (assuming the
		 * file was an image).  We use this information
		 * in the "data" function.
		 */
		$this->set_image_properties($this->upload_path.$file_name);
		array_push($this->file_names, $file_name);
		}
		return TRUE;
	}

	/**
	 * Validate Upload Path
	 *
	 * Verifies that it is a valid upload path with proper permissions.
	 *
	 *
	 * @return	bool
	 */
	public function validate_upload_path()
	{
		if ($this->upload_path == '')
		{
			$this->set_error('upload_no_filepath');
			return FALSE;
		}

		if (function_exists('realpath') AND @realpath($this->upload_path) !== FALSE)
		{
			$this->upload_path = str_replace("\\", "/", realpath($this->upload_path));
		}

		if ( ! @is_dir($this->upload_path))
		{
			$this->set_error('upload_no_filepath');
			return FALSE;
		}

		if ( ! is_really_writable($this->upload_path))
		{
			$this->set_error('upload_not_writable');
			return FALSE;
		}

		$this->upload_path = preg_replace("/(.+?)\/*$/", "\\1/",  $this->upload_path);
		return TRUE;
	}

	/**
	 * Verify that the filetype is allowed
	 *
	 * @return	bool
	 */
	public function is_allowed_filetype($key, $ignore_mime = FALSE)
	{
		if ($this->allowed_types == '*')
		{
			return TRUE;
		}

		if (count($this->allowed_types) == 0 OR ! is_array($this->allowed_types))
		{
			$this->set_error('upload_no_file_types');
			return FALSE;
		}

		$ext = strtolower(ltrim($this->file_ext, '.'));

		if ( ! in_array($ext, $this->allowed_types))
		{
			return FALSE;
		}

		// Images get some additional checks
		$image_types = array('gif', 'jpg', 'jpeg', 'png', 'jpe');

		if (in_array($ext, $image_types))
		{
			if (getimagesize($this->file_temp) === FALSE)
			{
				return FALSE;
			}
		}

		if ($ignore_mime === TRUE)
		{
			return TRUE;
		}

		$mime = $this->mimes_types($ext);

		if (is_array($mime))
		{
			if (in_array($this->file_type, $mime, TRUE))
			{
				return TRUE;
			}
		}
		elseif ($mime == $this->file_type)
		{
				return TRUE;
		}

		return FALSE;
	}

	// --------------------------------------------------------------------

}
// END tupload Class

/* End of file tupload.php */
/* Location: ./system/libraries/tupload.php */
