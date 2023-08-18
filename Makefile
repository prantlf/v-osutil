all: check test

check:
	v fmt -w .
	v vet .

test:
	v test_tools/stderr.v
	v test_tools/stdout.v
	v test .

clean:
	rm -rf src/*_test src/*.dSYM test_tools/stderr test_tools/stdout
