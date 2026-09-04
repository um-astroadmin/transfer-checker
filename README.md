# transfer-checker
Tools to verify that large datasets transfered correctly.

## scan.sh
Scanner to create a comparison set for use by _compare.sh_. Takes an optional directory path, or defaults to the current directory. Produces a comparison set to standard out.

**Example:** `./scan.sh test/src > test.set`

## compare.sh
Compare a directory to the information in a comparison set. Takes an optional directory path, or defaults to the current directory, and a comparison set via standard in. Generates a human-readable report of missing, mis-sized, and corrupted files.

**Example:** `./compare.sh test/dest < test.set`

Tools may be piped to avoid the need for a separate comparison set file.

**Example:** `./scan.sh test/src | ./compare.sh test/dest`