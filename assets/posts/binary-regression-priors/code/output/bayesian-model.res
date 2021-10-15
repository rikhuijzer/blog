Chains MCMC chain (10000×16×3 Array{Float64, 3}):

Iterations        = 1001:1:11000
Number of chains  = 3
Samples per chain = 10000
Wall duration     = 43.2 seconds
Compute duration  = 69.77 seconds
parameters        = intercept, βₐ, βᵣ, σ
internals         = lp, n_steps, is_accept, acceptance_rate, log_density, hamiltonian_energy, hamiltonian_energy_error, max_hamiltonian_energy_error, tree_depth, numerical_error, step_size, nom_step_size

Summary Statistics
  parameters      mean       std   naive_se      mcse          ess      rhat   ess_per_sec
      Symbol   Float64   Float64    Float64   Float64      Float64   Float64       Float64

   intercept    0.7718    1.3907     0.0080    0.0114   13465.2029    0.9999      192.9969
          βₐ    1.0480    0.0723     0.0004    0.0006   13680.4460    1.0000      196.0820
          βᵣ    1.0793    0.0344     0.0002    0.0002   19743.0958    1.0001      282.9781
           σ    1.1303    0.0736     0.0004    0.0006   19665.3448    1.0000      281.8636

Quantiles
  parameters      2.5%     25.0%     50.0%     75.0%     97.5%
      Symbol   Float64   Float64   Float64   Float64   Float64

   intercept   -1.9399   -0.1796    0.7724    1.7162    3.4954
          βₐ    0.9067    0.9989    1.0483    1.0965    1.1890
          βᵣ    1.0121    1.0561    1.0790    1.1025    1.1472
           σ    0.9961    1.0783    1.1270    1.1783    1.2837
