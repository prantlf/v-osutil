module osutil

import os { chdir, getwd }

const wd = getwd()

fn test_exist_in_none() {
	name := exist_in([], osutil.wd)
	assert name == none
}

fn test_exist_in_missing() {
	name := exist_in(['dummy'], osutil.wd)
	assert name == none
}

fn test_exist_in_existing() {
	name := exist_in(['v.mod'], osutil.wd)
	assert name? == 'v.mod'
}

fn test_exist_in_existing_2() {
	name := exist_in(['dummy', 'v.mod'], osutil.wd)
	assert name? == 'v.mod'
}

fn test_find_file_curdir() {
	dir, name := find_file('v.mod')?
	assert dir == osutil.wd
	assert name == '${osutil.wd}${os.path_separator}v.mod'
}

fn test_find_file_subdir() {
	chdir('src')!
	dir, name := find_file('v.mod')?
	chdir('..')!
	assert dir == osutil.wd
	assert name == '${osutil.wd}${os.path_separator}v.mod'
}

fn test_find_files_none() {
	find_files([]) or { return }
	assert false
}

fn test_find_files_missing() {
	find_files(['dummy']) or { return }
	assert false
}

fn test_find_files_curdir() {
	dir, name := find_files(['v.mod'])?
	assert dir == osutil.wd
	assert name == 'v.mod'
}

fn test_find_files_curdir_2() {
	dir, name := find_files(['dummy', 'v.mod'])?
	assert dir == osutil.wd
	assert name == 'v.mod'
}

fn test_find_files_subdir() {
	chdir('src')!
	dir, name := find_files(['v.mod'])?
	chdir('..')!
	assert dir == osutil.wd
	assert name == 'v.mod'
}

fn test_find_files_miss() {
	find_files_opt(['dummy'], osutil.wd, -1) or { return }
	assert false
}
