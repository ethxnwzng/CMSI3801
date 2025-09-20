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


export async function meaningfulLineCount(filename) {
  try {
    const fileStream = fs.createReadStream(filename, { encoding: "utf8" });

    const rl = readline.createInterface({
      input: fileStream,
      crlfDelay: Infinity,
    });

    let count = 0;
    for await (const line of rl) {
      // remove leading whitespace only
      const trimmed = line.trim();

      // skip if empty after trimming (covers empty + all whitespace lines)
      if (trimmed.length === 0) continue;

      // skip if first non-whitespace char is '#'
      if (trimmed[0] === "#") continue;

      // otherwise count it
      count++;
    }
    rl.close();
    fileStream.close();

    return count;
  } catch (err) {
    throw new Error(`Cannot read file: ${filename}, ${err.message}`);
  }
}


export function* powersGenerator({ ofBase, upTo }) {
  let power = 1;
  while (power <= upTo) {
    yield power;
    power *= ofBase;
  }
}

export function say(first) {
  if (first === undefined) return "";
  const parts = [String(first)];
  function accumulator(next) {
    if (next === undefined) return parts.join(" ");
    parts.push(String(next));
    return accumulator;
  }
  return accumulator;
}


export class Quaternion {
  constructor(a = 0, b = 0, c = 0, d = 0) {
    this.a = Number(a);
    this.b = Number(b);
    this.c = Number(c);
    this.d = Number(d);
    Object.freeze(this);
  }

  
  //coefficients()
  get coefficients() {
    return [this.a, this.b, this.c, this.d];
  }

  get conjugate() {
    return new Quaternion(this.a, -this.b, -this.c, -this.d);
  }
  //add
  plus(q) { return new Quaternion(this.a + q.a, this.b + q.b, this.c + q.c, this.d + q.d); }
  //mul
  times(q) {
    const { a, b, c, d } = this;
    const { a: e, b: f, c: g, d: h } = q;
    return new Quaternion(
      a*e - b*f - c*g - d*h,
      a*f + b*e + c*h - d*g,
      a*g - b*h + c*e + d*f,
      a*h + b*g - c*f + d*e
    );
  }

  // Exact equality
  equals(q) { return this.a === q.a && this.b === q.b && this.c === q.c && this.d === q.d; }

  toString() {
    // All zero
    if (this.a === 0 && this.b === 0 && this.c === 0 && this.d === 0) return "0";
  
    const parts = [];
  
    // real first (if present) — plain formatting, no ".0"
    if (this.a !== 0) parts.push(String(this.a));
  
    // helper for i, j, k terms
    const pushUnit = (coef, unit) => {
      if (coef === 0) return;
      const leading = parts.length === 0;
      const sign = coef < 0 ? "-" : (leading ? "" : "+");
      const mag = Math.abs(coef);
      const magStr = (mag === 1) ? "" : String(mag); // omit "1" for unit terms
      parts.push(`${sign}${magStr}${unit}`);
    };
  
    pushUnit(this.b, "i");
    pushUnit(this.c, "j");
    pushUnit(this.d, "k");
  
    return parts.join("");
  }
}