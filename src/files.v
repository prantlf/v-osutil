module osutil

import math { min }
import os { exists, join_path_single, real_path }
import prantlf.strutil { count_u8 }

pub fn exist_in(names []string, dir string) ?string {
	if d.is_enabled() {
		names_str := names.join('"", "')
		d.log_str('looking for names "${names_str}" in "${dir}"')
	}

	for name in names {
		mut file := join_path_single(dir, name)
		mut ddir := d.rwd(dir)
		d.log('checking if "%s" exists in "%s"', name, ddir)
		if exists(file) {
			d.log('"%s" found in "%s"', name, ddir)
			return name
		}
	}

	d.log_str('none of the names found')
	return none
}

@[inline]
pub fn find_file(name string) ?(string, string) {
	return find_file_opt(name, '.', -1)
}

pub fn find_file_opt(name string, start_dir string, depth int) ?(string, string) {
	d.log('looking for "%s"', name)
	mut dir := start_dir
	norm_depth := if depth < 0 { 10 } else { depth }
	real_depth := min(norm_depth, count_u8(real_path(dir), os.path_separator[0]) - 1)
	for _ in -1 .. real_depth {
		file := join_path_single(dir, name)
		mut ddir := d.rwd(dir)
		d.log('looking for in "%s"', ddir)
		if exists(file) {
			rdir := real_path(dir)
			ddir = d.rwd(rdir)
			d.log('found "%s" in "%s"', name, ddir)
			return rdir, join_path_single(rdir, name)
		}
		dir = join_path_single(dir, '..')
	}

	d.log('not found in "%s" and below', dir)
	return none
}

@[inline]
pub fn find_files(names []string) ?(string, string) {
	return find_files_opt(names, '.', -1)!
}

pub fn find_files_opt(names []string, start_dir string, depth int) ?(string, string) {
	if d.is_enabled() {
		names_str := names.join('"", "')
		d.log_str('looking for names "${names_str}"')
	}

	mut dir := start_dir
	norm_depth := if depth < 0 { 10 } else { depth }
	real_depth := min(norm_depth, count_u8(real_path(dir), os.path_separator[0]) - 1)
	for _ in -1 .. real_depth {
		mut ddir := d.rwd(dir)
		d.log('looking for in "%s"', ddir)
		if name := exist_in(names, dir) {
			rdir := real_path(dir)
			ddir = d.rwd(rdir)
			d.log('found "%s" in "%s"', name, ddir)
			return rdir, name
		}
		dir = join_path_single(dir, '..')
	}

	d.log_str('none of the names found')
	return none
}
