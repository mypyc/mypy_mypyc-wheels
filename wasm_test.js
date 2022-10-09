// Simple smoke test for WASM mypy wheels
const { loadPyodide } = require("pyodide");
const process = require("process");
const fs = require("fs");
const path = require('path');


const EXPECTED_ERROR = `test.py:1: error: Unsupported operand types for + ("int" and "str")
Found 1 error in 1 file (checked 1 source file)
`


async function test_mypy() {
  let pyodide = await loadPyodide();
  await pyodide.loadPackage("micropip")
  let micropip = pyodide.pyimport("micropip");
  await micropip.install([
    "typing_extensions>=3.10",
    "mypy_extensions>=0.4.3",
    "tomli>=1.1.0",
  ]);
  const dist_dir = "mypy/dist";
  const files = await fs.promises.readdir(dist_dir);
  await pyodide.loadPackage(path.join(dist_dir, files[0]));
  fs.readFile('build_wheel.py', 'utf8', function(err, data) {
    if (err) {
        console.log(err);
        process.exit(1);
    }
    pyodide.FS.writeFile('build_wheel.py', data);
  });
  pyodide.runPython(`
    with open('test.py', 'w') as f:
        f.write("1 + ''")
  `);
  return pyodide.runPython("import mypy.api; mypy.api.run(['test.py'])");
}


function assert(value, message) {
    if (!value) {
        console.log(message);
        process.exit(1);
    }
}


test_mypy().then((result) => {
  let [stdout, stderr, code] = result.toJs();
  assert(code === 1, "Exit code wasn't 1");
  assert(stderr === "", "Stderr not empty");
  assert(stdout === EXPECTED_ERROR, "Stdout not the expected value");
  console.log("Success! Tests passed as expected.");
});