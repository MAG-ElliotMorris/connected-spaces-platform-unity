#!/usr/bin/env python3

# WARNING AI GENERATED
# Script to take in a CSP include dir root, and create a mirrored
# directory structure populated with basic .i files.
# If there were no custom alterations, this would be the entire
# surface of the CSP api that SWIG could consume. Wrote this
# script to generate a starting point.

# USAGE: python3 GenInterfaceFiles.py /path/to/csp/include/root /path/to/output


import argparse
import os
from pathlib import Path

def generate_i_files(src_root: Path, dst_root: Path) -> None:
    src_root = src_root.resolve()
    dst_root = dst_root.resolve()

    for dirpath, dirnames, filenames in os.walk(src_root):
        dirpath = Path(dirpath)
        rel_dir = dirpath.relative_to(src_root)

        # Mirror directory structure
        out_dir = dst_root / rel_dir
        out_dir.mkdir(parents=True, exist_ok=True)

        for name in filenames:
            if not name.endswith(".h"):
                continue

            header_path = dirpath / name
            # Path to use inside #include / %include: relative to src_root, POSIX-style
            rel_header = header_path.relative_to(src_root).as_posix()

            i_name = Path(name).with_suffix(".i").name
            i_path = out_dir / i_name

            content = f"""%{{
#include "{rel_header}"
%}}

%include "{rel_header}"
"""

            i_path.write_text(content, encoding="utf-8")
            # Uncomment if you want to see what’s being generated:
            # print(f"Created {i_path} for {header_path}")

def main():
    parser = argparse.ArgumentParser(
        description="Mirror a header tree and generate matching .i files."
    )
    parser.add_argument("src_root", type=Path, help="Source root directory to scan for .h files")
    parser.add_argument(
        "dst_root",
        type=Path,
        help="Destination root directory where the mirrored structure and .i files will be created",
    )

    args = parser.parse_args()
    generate_i_files(args.src_root, args.dst_root)

if __name__ == "__main__":
    main()