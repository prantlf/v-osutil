module osutil

import os
import strings { new_builder }
import prantlf.debug { new_debug }
import prantlf.strutil {
	first_line,
	str_within,
	str_without_leading_whitespace,
	str_without_trailing_whitespace,
	str_without_whitespace,
}

const d = new_debug('osutil')

pub struct ExecuteOpts {
	trim_leading_whitespace  bool
	trim_trailing_whitespace bool
	trim_trailing_line_break bool = true
}

pub fn execute(cmd string) !string {
	return execute_opt(cmd, ExecuteOpts{})!
}

pub fn execute_opt(cmd string, opts &ExecuteOpts) !string {
	osutil.d.log('execute "%s"', cmd)
	f := vpopen(cmd)
	if isnil(f) {
		return error('executing "${cmd}" failed')
	}
	fd := os.fileno(f)
	out := read_all(fd, opts)
	exit_code := vpclose(f)
	if exit_code != 0 {
		return error('"${cmd}"" exited with ${exit_code}: ${first_line(out)}')
	}
	osutil.d.log('received %d bytes', out.len)
	return out
}

fn vpopen(path string) voidptr {
	$if windows {
		wmode := 'rb'.to_wide()
		wpath := path.to_wide()
		return C._wpopen(wpath, wmode)
	} $else {
		return C.popen(path.str, c'r')
	}
}

fn vpclose(f voidptr) int {
	$if windows {
		return C._pclose(f)
	} $else {
		res := C.pclose(f)
		return if C.WIFEXITED(res) {
			C.WEXITSTATUS(res)
		} else if C.WIFSIGNALED(res) {
			C.WTERMSIG(res)
		} else {
			-1
		}
	}
}

[manualfree]
fn read_all(fd int, opts &ExecuteOpts) string {
	mut res := new_builder(1024)
	defer {
		unsafe { res.free() }
	}
	buf := [4096]u8{}
	unsafe {
		pbuf := &buf[0]
		for {
			len := C.read(fd, pbuf, 4096)
			if len == 0 {
				break
			}
			res.write_ptr(pbuf, len)
		}
	}
	if res.len == 0 {
		return ''
	}
	return if opts.trim_leading_whitespace {
		if opts.trim_trailing_whitespace {
			str_without_whitespace(mut res)
		} else {
			str_without_leading_whitespace(mut res)
		}
	} else if opts.trim_trailing_whitespace {
		str_without_trailing_whitespace(mut res)
	} else if opts.trim_trailing_line_break {
		mut end := res.len
		if res[end - 1] == `\n` {
			end--
			if res[end - 1] == `\r` {
				end--
			}
			str_within(mut res, 0, end)
		} else {
			res.str()
		}
	} else {
		res.str()
	}
}
