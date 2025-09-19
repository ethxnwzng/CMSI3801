function findAndApply(a, p, f) {
    for (let x of a) {
      if (p(x)) {
        return f(x);
      }
    }
    return null; // representation of "non-existence"
  }