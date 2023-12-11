all: check test

check:
	v fmt -w .
	v vet .

test:
	v -use-os-system-to-run test_tools/stderr.v
	v -use-os-system-to-run test_tools/stdout.v
	v -use-os-system-to-run test .

clean:
	rm -rf src/*_test src/*.dSYM test_tools/stderr test_tools/stdout
