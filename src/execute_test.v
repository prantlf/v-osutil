module osutil

fn test_execute_without_output() {
	assert execute('test_tools/stderr')! == ''
}

fn test_execute_with_output() {
	assert execute('test_tools/stdout none')! == 'stdout'
}

fn test_execute_with_output_with_space() {
	assert execute('test_tools/stdout both')! == ' stdout '
}

fn test_execute_with_output_with_line_break() {
	assert execute_opt('test_tools/stdout both', ExecuteOpts{
		trim_trailing_line_break: false
	})! == ' stdout \n'
}

fn test_execute_with_output_without_space() {
	assert execute_opt('test_tools/stdout both', ExecuteOpts{
		trim_leading_whitespace: true
		trim_trailing_whitespace: true
	})! == 'stdout'
}

fn test_execute_with_output_without_leading_space() {
	assert execute_opt('test_tools/stdout both', ExecuteOpts{
		trim_leading_whitespace: true
	})! == 'stdout \n'
}

fn test_execute_with_output_without_trailling_space() {
	assert execute_opt('test_tools/stdout both', ExecuteOpts{
		trim_trailing_whitespace: true
	})! == ' stdout'
}
