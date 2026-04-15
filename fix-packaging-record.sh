#!/bin/bash
# Generate a missing RECORD file for the apt-installed python3-packaging.
#
# Debian/Ubuntu intentionally omit RECORD files from apt-managed Python
# packages. pip >= 26 needs a RECORD to uninstall a package, so it refuses
# to upgrade packaging with "uninstall-no-record-file". This script creates
# the RECORD so pip can replace the apt version cleanly.

set -euo pipefail

dist_info=$(python3 -c "
import importlib.metadata
print(importlib.metadata.distribution('packaging')._path)
")

cd "$(dirname "$dist_info")"
find packaging packaging-*.dist-info -type f \
    | sed 's/$/,,/' \
    > "$dist_info/RECORD"

echo "Generated RECORD for python3-packaging at $dist_info/RECORD"
