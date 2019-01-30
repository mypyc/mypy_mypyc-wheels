function pre_build {
    pip install virtualenv
    pip install -r mypy/mypyc-requirements.txt
}

function run_tests {
    true
}
