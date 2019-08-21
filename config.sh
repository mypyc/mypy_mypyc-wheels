function pre_build {
    pip install virtualenv
    pip install -r mypy/mypy-requirements.txt
}

function run_tests {
    true
}
