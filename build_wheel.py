"""Script to build compiled binary wheels that can be uploaded to PyPI.

The main GitHub workflow where this script is used:
https://github.com/mypyc/mypy_mypyc-wheels/blob/master/.github/workflows/build.yml

This uses cibuildwheel (https://github.com/pypa/cibuildwheel) to build the wheels.

Usage:

  build_wheel.py --python-version <python-version> --output-dir <dir>

Wheels for the given Python version will be created in the given directory.
Python version is in form "39".

This works on macOS, Windows and Linux.

You can test locally by using --extra-opts. macOS example:

  python build_wheel.py --mypy-root-dir ~/dev/mypy --python-version 39 --output-dir out --extra-opts="--platform macos"
"""

import argparse
import os
import subprocess
from typing import Dict


def create_environ(python_version: str) -> Dict[str, str]:
    """Set up environment variables for cibuildwheel."""
    env = os.environ.copy()

    env["CIBW_BUILD"] = f"cp{python_version}-*"

    return env


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--mypy-root-dir", required=True, metavar="DIR", help="Location of mypy checkout"
    )
    parser.add_argument(
        "--python-version", required=True, metavar="XY", help="Python version (e.g. 38 or 39)"
    )
    parser.add_argument(
        "--output-dir", required=True, metavar="DIR", help="Output directory for created wheels"
    )
    parser.add_argument(
        "--extra-opts",
        default="",
        metavar="OPTIONS",
        help="Extra options passed to cibuildwheel verbatim",
    )
    args = parser.parse_args()
    mypy_root_dir = args.mypy_root_dir
    python_version = args.python_version
    output_dir = args.output_dir
    extra_opts = args.extra_opts
    environ = create_environ(python_version)
    script = f"python -m cibuildwheel --config-file=cibuildwheel.toml {extra_opts} --output-dir {output_dir} {mypy_root_dir}"
    subprocess.check_call(script, shell=True, env=environ)


if __name__ == "__main__":
    main()
