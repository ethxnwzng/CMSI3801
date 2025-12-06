using Distributed
num_workers = length(ARGS) > 0 ? parse(Int, ARGS[1]) : 1
addprocs(num_workers)

@everywhere function approximate_pi(trials::Int)
    hits = 0
    for i in 1:trials
        hits += (rand()^2 + rand()^2 < 1) ? 1 : 0
    end
    return hits
end

function main()
    total_trials = 500_000_000
    trials_per_worker = div(total_trials, nworkers())
    hits = pmap(w -> approximate_pi(trials_per_worker), workers())
    return 4 * sum(hits) / total_trials
end

println("Estimating π with $(nworkers()) workers...")
@time estimate = main()
println("π ≈ $estimate")

# Execution times recorded:
# 1 worker:  2.674646 seconds
# 2 workers: 1.954975 seconds
# 3 workers: 2.041862 seconds
# 4 workers: 1.686185 seconds
# 5 workers: 1.960552 seconds
# 6 workers: 1.866652 seconds
# 7 workers: 1.810542 seconds
# 8 workers: 1.752632 seconds
# 9 workers: 2.805996 seconds
# 10 workers: 2.244831 seconds
# 11 workers: 2.990119 seconds
# 12 workers: 2.812343 seconds
# 13 workers: 3.995962 seconds
# 14 workers: 3.259967 seconds
# 15 workers: 3.401183 seconds
# 16 workers: 3.550960 seconds
# 17 workers: 5.265323 seconds
# 18 workers: 4.204814 seconds
# 19 workers: 6.272220 seconds
# 20 workers: 4.744451 seconds

