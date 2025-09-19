class Quaternion {
    constructor(a = 0, b = 0, c = 0, d = 0) {
      this.a = Number(a); // real
      this.b = Number(b); // i
      this.c = Number(c); // j
      this.d = Number(d); // k
      Object.freeze(this);
    }
  
    add(q) {
      return new Quaternion(
        this.a + q.a,
        this.b + q.b,
        this.c + q.c,
        this.d + q.d
      );
    }
  
    mul(q) {
      const { a, b, c, d } = this;
      const { a: e, b: f, c: g, d: h } = q;
      return new Quaternion(
        a*e - b*f - c*g - d*h,
        a*f + b*e + c*h - d*g,
        a*g - b*h + c*e + d*f,
        a*h + b*g - c*f + d*e
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
  
    // String form: a + b i + c j + d k
    toString() {
      const signTerm = (coef, sym) =>
        (coef < 0 ? ` - ${Math.abs(coef)} ${sym}` : ` + ${coef} ${sym}`);
      return `${this.a}`
        + signTerm(this.b, "i")
        + signTerm(this.c, "j")
        + signTerm(this.d, "k");
    }
  }
  
module.exports = { Quaternion };