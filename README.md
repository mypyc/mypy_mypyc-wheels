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
```
pip install --upgrade --find-links https://github.com/mypyc/mypy_mypyc-wheels/releases/tag/v0.920+dev.48181d26e7575aece8cab61eb866ac6c573dfd76 mypy
# or possibly
pip install --upgrade --find-links https://github.com/mypyc/mypy_mypyc-wheels/releases/latest mypy
```
