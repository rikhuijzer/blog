Chains MCMC chain (10000×16×3 Array{Float64, 3}):

Iterations        = 1:10000
Thinning interval = 1
Number of chains  = 3
Samples per chain = 10000
Wall duration     = 55.54 seconds
Compute duration  = 52.87 seconds
parameters        = σ, intercept, βₐ, βᵣ
internals         = lp, n_steps, is_accept, acceptance_rate, log_density, hamiltonian_energy, hamiltonian_energy_error, max_hamiltonian_energy_error, tree_depth, numerical_error, step_size, nom_step_size

Summary Statistics
  parameters      mean       std   naive_se      mcse          ess      rhat   ess_per_sec
      Symbol   Float64   Float64    Float64   Float64      Float64   Float64       Float64

   intercept    0.7981    1.3815     0.0080    0.0119   13757.3112    1.0002      260.2102
          βₐ    1.0468    0.0716     0.0004    0.0006   13860.9681    1.0002      262.1708
          βᵣ    1.0788    0.0341     0.0002    0.0002   19017.6778    0.9999      359.7064
           σ    1.1291    0.0743     0.0004    0.0006   18747.2740    1.0000      354.5919

Quantiles
  parameters      2.5%     25.0%     50.0%     75.0%     97.5%
      Symbol   Float64   Float64   Float64   Float64   Float64

   intercept   -1.9019   -0.1375    0.7969    1.7247    3.5196
          βₐ    0.9063    0.9988    1.0468    1.0952    1.1858
          βᵣ    1.0120    1.0560    1.0787    1.1017    1.1462
           σ    0.9953    1.0771    1.1247    1.1766    1.2868
