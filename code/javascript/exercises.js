// exercises.js

import fs from "fs";
import readline from "readline";

/** findThenApply / firstThenApply */
export function firstThenApply(a, p, f) {
  for (const x of a) {
    if (p(x)) return f(x);
  }
  return undefined; // test expects undefined as the "non-existence" value
}; // alias expected by tests



/** meaningfulLineCount: count non-empty, non-whitespace, non-# lines */
// import fs from "fs";
// import readline from "readline";

// export async function meaningfulLineCount(filename) {
//   const fileStream = fs.createReadStream(filename, { encoding: "utf8" });

//   const rl = readline.createInterface({
//     input: fileStream,
//     crlfDelay: Infinity // handles both \n and \r\n
//   });

//   let count = 0;
//   for await (const line of rl) {
//     const trimmed = line.trim();
//     if (trimmed.length > 0 && !trimmed.startsWith("#")) {
//       count++;
//     }
//   }

//   return count;
// }



export async function meaningfulLineCount(filename) {
  try {
    const fileStream = fs.createReadStream(filename, { encoding: "utf8" });

    const rl = readline.createInterface({
      input: fileStream,
      // crlfDelay: Infinity,
    });

    let count = 0;
    for await (const line of rl) {
      // remove leading whitespace only
      const trimmed = line.trimStart();

      // skip if empty after trimming (covers empty + all whitespace lines)
      if (trimmed.length === 0) continue;

      // skip if first non-whitespace char is '#'
      if (trimmed[0] === "#") continue;

      // otherwise count it
      count++;
    }

    return count;
  } catch (err) {
    throw new Error(`Cannot read file: ${filename}, ${err.message}`);
  }
}





/** powersGenerator: yields b^0, b^1, ... for expCount terms */
// Yield powers of `ofBase` starting at 1, while <= upTo
export function* powersGenerator({ ofBase, upTo }) {
  let power = 1;
  while (power <= upTo) {
    yield power;
    power *= ofBase;
  }
}




/** say: chain words; calling with no arg ends and returns quoted string */
export function say(first) {
  if (first === undefined) return "";
  const parts = [String(first)];
  function acc(next) {
    if (next === undefined) return parts.join(" ");
    parts.push(String(next));
    return acc;
  }
  return acc;
}



/** Quaternion */
export class Quaternion {
  constructor(a = 0, b = 0, c = 0, d = 0) {
    this.a = Number(a);
    this.b = Number(b);
    this.c = Number(c);
    this.d = Number(d);
    Object.freeze(this);
  }
  add(q) {
    return new Quaternion(this.a + q.a, this.b + q.b, this.c + q.c, this.d + q.d);
  }
  mul(q) {
    const { a, b, c, d } = this;
    const { a: e, b: f, c: g, d: h } = q;
    return new Quaternion(
      a * e - b * f - c * g - d * h,
      a * f + b * e + c * h - d * g,
      a * g - b * h + c * e + d * f,
      a * h + b * g - c * f + d * e
    );
  }
  coeffs() { return [this.a, this.b, this.c, this.d]; }
  conj() { return new Quaternion(this.a, -this.b, -this.c, -this.d); }
  equals(q, eps = 0) {
    return (
      Math.abs(this.a - q.a) <= eps &&
      Math.abs(this.b - q.b) <= eps &&
      Math.abs(this.c - q.c) <= eps &&
      Math.abs(this.d - q.d) <= eps
    );
  }
  toString() {
    const s = (coef, sym) => (coef < 0 ? ` - ${Math.abs(coef)} ${sym}` : ` + ${coef} ${sym}`);
    return `${this.a}${s(this.b, "i")}${s(this.c, "j")}${s(this.d, "k")}`;
  }
}
