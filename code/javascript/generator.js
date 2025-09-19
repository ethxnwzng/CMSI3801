function* powerGenerator(b, limit) {
    let power = 1; // b^0 = 1
    while (power <= limit) {
      yield power;
      power *= b;
    }
  }