const fs   = require("fs");
const Path = require("path");

module.exports.readFiles = function(filenames) {
  // Create a map of filename->text
  const assoc = filenames.map(filename => {
    const path = Path.join(__dirname, "assets", filename);
    const text = fs.readFileSync(path, "utf-8");
    return {[filename]: text.replace("\n", "")};
  });

  // Flatten array into key-value object
  return assoc.reduce((a, b, {}) => Object.assign(a, b));
}

module.exports.uts = function(unix_time_string) {
  const date = new Date(1000 * parseInt(unix_time_string));
  return date.toLocaleString();
}
