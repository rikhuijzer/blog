Chains MCMC chain (10000×16×3 Array{Float64, 3}):

Iterations        = 1001:1:11000
Number of chains  = 3
Samples per chain = 10000
Wall duration     = 47.17 seconds
Compute duration  = 44.27 seconds
parameters        = σ, intercept, βₐ, βᵣ
internals         = lp, n_steps, is_accept, acceptance_rate, log_density, hamiltonian_energy, hamiltonian_energy_error, max_hamiltonian_energy_error, tree_depth, numerical_error, step_size, nom_step_size

Summary Statistics
  parameters      mean       std   naive_se      mcse          ess      rhat   ess_per_sec
      Symbol   Float64   Float64    Float64   Float64      Float64   Float64       Float64

   intercept    0.7827    1.3931     0.0080    0.0122   12620.9814    1.0002      285.0653
          βₐ    1.0473    0.0723     0.0004    0.0006   12787.4879    1.0002      288.8261
          βᵣ    1.0797    0.0339     0.0002    0.0002   19906.4505    1.0000      449.6194
           σ    1.1291    0.0747     0.0004    0.0005   18283.2070    1.0002      412.9558

Quantiles
  parameters      2.5%     25.0%     50.0%     75.0%     97.5%
      Symbol   Float64   Float64   Float64   Float64   Float64

   intercept   -1.9645   -0.1582    0.7913    1.7176    3.5009
          βₐ    0.9063    0.9986    1.0474    1.0957    1.1897
          βᵣ    1.0130    1.0568    1.0798    1.1027    1.1457
           σ    0.9935    1.0769    1.1256    1.1772    1.2848
