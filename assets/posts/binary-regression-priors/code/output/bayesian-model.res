Chains MCMC chain (10000×16×3 Array{Float64, 3}):

Iterations        = 1001:1:11000
Number of chains  = 3
Samples per chain = 10000
Wall duration     = 53.9 seconds
Compute duration  = 50.4 seconds
parameters        = σ, intercept, βₐ, βᵣ
internals         = lp, n_steps, is_accept, acceptance_rate, log_density, hamiltonian_energy, hamiltonian_energy_error, max_hamiltonian_energy_error, tree_depth, numerical_error, step_size, nom_step_size

Summary Statistics
  parameters      mean       std   naive_se      mcse          ess      rhat   ess_per_sec
      Symbol   Float64   Float64    Float64   Float64      Float64   Float64       Float64

   intercept    0.7791    1.3941     0.0080    0.0133   11397.3520    1.0001      226.1379
          βₐ    1.0477    0.0725     0.0004    0.0007   11520.6762    1.0001      228.5848
          βᵣ    1.0789    0.0338     0.0002    0.0002   18278.3154    1.0000      362.6650
           σ    1.1298    0.0739     0.0004    0.0006   16996.1717    1.0001      337.2256

Quantiles
  parameters      2.5%     25.0%     50.0%     75.0%     97.5%
      Symbol   Float64   Float64   Float64   Float64   Float64

   intercept   -1.9703   -0.1551    0.7792    1.7185    3.5196
          βₐ    0.9052    0.9986    1.0477    1.0961    1.1897
          βᵣ    1.0128    1.0559    1.0787    1.1019    1.1454
           σ    0.9960    1.0787    1.1256    1.1775    1.2855
