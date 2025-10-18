// for meaningful line count
import { readFile } from "node:fs/promises";

//find first a[i] satisfying p, apply f, else undefined
export function firstThenApply<A, B>(
    a: ReadonlyArray<A>,
    p: (x: A) => boolean,
    f: (x: A) => B
  ): B | undefined {
    for (const x of a) {
      if (p(x)) return f(x);
    }
    return undefined;
  }
  
  //infinite generator b^0...
  export function* powersGenerator(base: bigint): Generator<bigint, void, void> {
    let current = 1n;
    while (true) {
      yield current;
      current *= base;
    }
  }
  
  //async to constantly run function even if lines are being processed
  // count non empty, non-whitespace
  export async function meaningfulLineCount(path: string): Promise<number> {
    const text = await readFile(path, { encoding: "utf8" }); //let readFile throw if missing
    const lines = text.split(/\r?\n/);
    let count = 0;
    for (const line of lines) {
      if (!/\S/.test(line)) continue; //empty or whitespace only
      const firstNonWs = line.match(/^\s*(.)/);
      if (firstNonWs && firstNonWs[1] === "#") continue;
      count++;
    }
    return count;
  }
  
  //union type + volume and surfaceArea
  export type Shape =
    | { kind: "Sphere"; radius: number }
    | { kind: "Box"; width: number; length: number; depth: number };
  
  export function volume(shape: Shape): number {
    switch (shape.kind) {
      case "Sphere":
        return (4 / 3) * Math.PI * Math.pow(shape.radius, 3);
      case "Box":
        return shape.width * shape.length * shape.depth;
    }
  }
  
  export function surfaceArea(shape: Shape): number {
    switch (shape.kind) {
      case "Sphere":
        return 4 * Math.PI * Math.pow(shape.radius, 2);
      case "Box":
        const { width, length, depth } = shape;
        return 2 * (width * length + width * depth + length * depth);
    }
  }
  
  // 5) Immutable Binary Search Tree with inorder generator

  //tests need:
  // - class Empty<T> implements BinarySearchTree<T>
  // - insert/contains/size/inorder()/toString()
  // - toString(): "()" for empty; nodes use "("+left+value+right+")" with empty children omitted
  
  export abstract class BinarySearchTree<T> {
    abstract size(): number;
    abstract contains(x: T): boolean;
    abstract insert(x: T): BinarySearchTree<T>;
    abstract inorder(): Iterable<T>;
    toString(): string {
      return this.repr(false);
    }
    protected abstract repr(inner: boolean): string;
  }
  
  //default comparator chosen from first inserted value’s type
  function makeDefaultComparator<T>(sample: T): (a: T, b: T) => number {
    const t = typeof sample;
    if (t === "number" || t === "bigint") {
      return (a: any, b: any) => (a < b ? -1 : a > b ? 1 : 0);
    }
    if (t === "string") {
      return (a: any, b: any) => (a as string).localeCompare(b as string);
    }
    if (t === "boolean") {
      // false < true
      return (a: any, b: any) => (a === b ? 0 : a === false ? -1 : 1);
    }
    //fallback: use string representation (keeps tests happy for used types)
    return (a: any, b: any) => `${a}`.localeCompare(`${b}`);
  }
  
  export class Empty<T> extends BinarySearchTree<T> {
    constructor(private readonly cmp?: (a: T, b: T) => number) {
      super();
    }
    size(): number {
      return 0;
    }
    contains(_: T): boolean {
      return false;
    }
    insert(x: T): BinarySearchTree<T> {
      const cmp = this.cmp ?? makeDefaultComparator(x);
      return new Node<T>(x, new Empty<T>(cmp), new Empty<T>(cmp), cmp);
    }
    *inorder(): Iterable<T> {}
    protected repr(inner: boolean): string {
      return inner ? "" : "()";
    }
  }
  
  class Node<T> extends BinarySearchTree<T> {
    constructor(
      private readonly value: T,
      private readonly left: BinarySearchTree<T>,
      private readonly right: BinarySearchTree<T>,
      private readonly cmp: (a: T, b: T) => number
    ) {
      super();
    }
    size(): number {
      return 1 + this.left.size() + this.right.size();
    }
    contains(x: T): boolean {
      const c = this.cmp(x, this.value);
      if (c === 0) return true;
      if (c < 0) return this.left.contains(x);
      return this.right.contains(x);
    }
    insert(x: T): BinarySearchTree<T> {
      const c = this.cmp(x, this.value);
      if (c === 0) return this; //ignore duplicates
      if (c < 0) return new Node(this.value, this.left.insert(x), this.right, this.cmp);
      return new Node(this.value, this.left, this.right.insert(x), this.cmp);
    }
    *inorder(): Iterable<T> {
      yield* this.left.inorder();
      yield this.value;
      yield* this.right.inorder();
    }
    protected repr(inner: boolean): string {
      //for inner contexts, empty children render as ""
      const ls = (this.left as any).repr(true) as string;
      const rs = (this.right as any).repr(true) as string;
      return `(${ls}${this.value}${rs})`;
    }
  }