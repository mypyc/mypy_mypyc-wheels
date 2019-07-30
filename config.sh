function pre_build {
    pip install virtualenv
    if [ -f mypy/mypyc-requirements.txt ]; then
	pip install -r mypy/mypyc-requirements.txt
    fi
}

function run_tests {
    true
}
