// Simple smoke test for WASM mypy wheels
const { loadPyodide } = require("pyodide");
const process = require("process");
const fs = require("fs");
const path = require("path");


const EXPECTED_ERROR = `test.py:1: error: Unsupported operand types for + ("int" and "str")
Found 1 error in 1 file (checked 1 source file)
`


async function test_mypy() {
  let pyodide = await loadPyodide();
  await pyodide.loadPackage("micropip")
  let micropip = pyodide.pyimport("micropip");
  let requirements = fs.readFileSync("mypy/mypy-requirements.txt", {encoding: "utf8"});
  await Promise.all(
    requirements.split("\n").map(async (requirement) => {
      if (!requirement.startsWith("#") && requirement != "") {
        await micropip.install([requirement]);
      }
    })
  );
  const dist_dir = "mypy/dist";
  const files = await fs.promises.readdir(dist_dir);
  await pyodide.loadPackage(path.join(dist_dir, files[0]));
  pyodide.runPython(`
    with open('test.py', 'w') as f:
        f.write("1 + ''")
  `);
  return pyodide.runPython("import mypy.api; mypy.api.run(['test.py'])");
}


function assert(value, expected, message) {
    if (value != expected) {
        console.log(message);
        console.log(value);
        process.exit(1);
    }
}


test_mypy().then((result) => {
  let [stdout, stderr, code] = result.toJs();
  assert(code, 1, "Exit code wasn't 1");
  assert(stderr, "", "Stderr not empty");
  assert(stdout, EXPECTED_ERROR, "Stdout not the expected value");
  console.log("Success! Tests passed as expected.");
});
