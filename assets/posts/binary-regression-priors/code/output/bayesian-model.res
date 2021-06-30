Chains MCMC chain (10000×16×3 Array{Float64, 3}):

Iterations        = 1:1:10000
Number of chains  = 3
Samples per chain = 10000
Wall duration     = 78.68 seconds
Compute duration  = 75.85 seconds
parameters        = σ, intercept, βₐ, βᵣ
internals         = lp, n_steps, is_accept, acceptance_rate, log_density, hamiltonian_energy, hamiltonian_energy_error, max_hamiltonian_energy_error, tree_depth, numerical_error, step_size, nom_step_size

Summary Statistics
  parameters      mean       std   naive_se      mcse          ess      rhat   ess_per_sec
      Symbol   Float64   Float64    Float64   Float64      Float64   Float64       Float64

   intercept    0.7781    1.3891     0.0080    0.0112   14276.4590    1.0000      188.2221
          βₐ    1.0476    0.0721     0.0004    0.0006   14602.5222    1.0000      192.5210
          βᵣ    1.0796    0.0344     0.0002    0.0002   19352.9769    1.0003      255.1514
           σ    1.1291    0.0743     0.0004    0.0006   18675.9910    1.0002      246.2259

Quantiles
  parameters      2.5%     25.0%     50.0%     75.0%     97.5%
      Symbol   Float64   Float64   Float64   Float64   Float64

   intercept   -1.9642   -0.1684    0.7894    1.7140    3.5028
          βₐ    0.9066    0.9992    1.0468    1.0967    1.1900
          βᵣ    1.0121    1.0567    1.0795    1.1025    1.1472
           σ    0.9951    1.0775    1.1247    1.1758    1.2892
