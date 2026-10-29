# transfer-checker
Tools to verify that large datasets transfered correctly.

## scan.sh
Scanner to create a comparison set for use by _compare.sh_. Takes an optional directory path, or defaults to the current directory. Produces a comparison set to standard out.

*Optional flag -f, puts the scanner into "fast mode" which only gets size, but does not compute a checksum.*

**Example:** `./scan.sh test/src > test.set`

## compare.sh
Compare a directory to the information in a comparison set. Takes an optional directory path, or defaults to the current directory, and a comparison set via standard in. Generates a human-readable report of missing, mis-sized, and corrupted files.

*If the scanner was run in "fast mode", corrupted files with matching sizes cannot be detected.*

**Example:** `./compare.sh test/dest < test.set`

Tools may be piped to avoid the need for a separate comparison set file.

**Example:** `./scan.sh test/src | ./compare.sh test/dest`