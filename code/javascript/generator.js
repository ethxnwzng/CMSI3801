function* powerGenerator(b, expCount) {
    let power = 1;                 // b^0
    for (let i = 0; i < expCount; i++) {
      yield power;                 // b^i
      power *= b;                  // next: b^(i+1)
    }
  }
  
  const [b, n] = process.argv.slice(2).map(Number);
  
  let sum = 0;
  for (const p of powerGenerator(b, n)) sum += p;
  
  console.log(sum);


// node generator.js {number} {limit for summing power}