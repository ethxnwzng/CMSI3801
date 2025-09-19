const { countValidLines } = require("./countValidLines");


(async () => {
    try {
      const result = await countValidLines("test.txt");
      console.log("Valid line count:", result);
    } catch (err) {
      console.error("Error:", err.message);
    }
  })();
  