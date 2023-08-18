module main

import os

fn main() {
	lead, trail := match os.args[1] {
		'lead' {
			' ', ''
		}
		'trail' {
			'', ' '
		}
		'both' {
			' ', ' '
		}
		else {
			'', ''
		}
	}
	println('${lead}stdout${trail}')
}
