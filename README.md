# osutil

Utilities for interacting with the underlying operating system.

## Installation

You can install this package either from [VPM] or from GitHub:

```txt
v install prantlf.osutil
v install --git https://github.com/prantlf/v-osutil
```

## API

The following types and functions are exported:

### Types

    pub struct ExecuteOpts {
      trim_leading_whitespace  bool
	  trim_trailing_whitespace bool
	  trim_leading_line_break bool
	  trim_trailing_line_break bool = true
    }

### Functions

    execute(cmd string) !string
    execute_opt(cmd string, opts &ExecuteOpts) !string

    exist_in(names []string, dir string) ?string
    find_file(name string) ?(string, string)
    find_file_opt(name string, start_dir string, depth int) ?(string, string)
    find_files(names []string) ?(string, string)
    find_files_opt(names []string, start_dir string, depth int) ?(string, string)

## Contributing

In lieu of a formal styleguide, take care to maintain the existing coding style. Lint and test your code.

## License

Copyright (c) 2023-2025 Ferdinand Prantl

Licensed under the MIT license.

[VPM]: https://vpm.vlang.io/packages/prantlf.osutil
