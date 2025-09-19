const fs = require("fs");
const readline = require("readline");

async function countValidLines(filename) {
  const fileStream = fs.createReadStream(filename, { encoding: "utf8" });

  const rl = readline.createInterface({
    input: fileStream,
    crlfDelay: Infinity // handles both \n and \r\n
  });

  let count = 0;
  for await (const line of rl) {
    const trimmed = line.trim();
    if (trimmed.length > 0 && !trimmed.startsWith("#")) {
      count++;
    }
  }

  return count;
}

module.exports = { countValidLines };
