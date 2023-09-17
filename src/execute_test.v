module osutil

import os

fn test_execute_without_output() {
	assert execute('test_tools${os.path_separator}stderr')! == ''
}

fn test_execute_with_output() {
	assert execute('test_tools${os.path_separator}stdout none')! == 'stdout'
}

fn test_execute_with_output_with_space() {
	assert execute('test_tools${os.path_separator}stdout both')! == ' stdout '
}

fn test_execute_with_output_with_line_break() {
	$if !windows {
		assert execute_opt('test_tools${os.path_separator}stdout both', ExecuteOpts{
			trim_trailing_line_break: false
		})! == ' stdout \n'
	}
}

fn test_execute_with_output_without_space() {
	assert execute_opt('test_tools${os.path_separator}stdout both', ExecuteOpts{
		trim_leading_whitespace: true
		trim_trailing_whitespace: true
	})! == 'stdout'
}

fn test_execute_with_output_without_leading_space() {
	$if !windows {
		assert execute_opt('test_tools${os.path_separator}stdout both', ExecuteOpts{
			trim_leading_whitespace: true
		})! == 'stdout \n'
	}
}

fn test_execute_with_output_without_trailling_space() {
	assert execute_opt('test_tools${os.path_separator}stdout both', ExecuteOpts{
		trim_trailing_whitespace: true
	})! == ' stdout'
}
