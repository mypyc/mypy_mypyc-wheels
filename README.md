# mypy_mypyc-wheels
Automated building and storage of mypyc-compiled mypy binaries

![Build wheels status](https://github.com/mypyc/mypy_mypyc-wheels/workflows/Build%20wheels/badge.svg)

## Things to know

Typically, you'll want to report issues on the main mypy repo (not many people
watch this repo)

If you're running into weird issues with a pull request, try updating the
`mypy_commit` file to the latest hash from the mypy repo.

If wheels aren't getting built, debug over at
https://github.com/mypyc/mypy_mypyc-wheels/actions

You can use pip to install these wheels like so:
```bash
pip install --upgrade --find-links https://github.com/KotlinIsland/mypy_mypyc-wheels/releases basedmypy
# or if you need a specific version
pip install --upgrade --find-links https://github.com/KotlinIsland/mypy_mypyc-wheels/releases basedmypy==1.6.0+dev.8e2443a74c9fb1726dc2c730b5e469881d3c1acf
```

##  Building locally

With [pipx](https://pipx.pypa.io) installed, run:

```bash
COMMIT=$(cat mypy_commit)
git clone https://github.com/python/mypy.git --recurse-submodules
(cd mypy && git checkout $COMMIT)
pipx run cibuildwheel --config=cibuildwheel.toml mypy
```

Optionally add `--only=<identifier>` to build only one wheel, or set
`CIBW_BUILD` to some expression like `cp311-*` and include `--platform linux`
(or some other platform). Optionally pin cibuildwheel to the version specified
in `.github/workflows/build.yml`.
