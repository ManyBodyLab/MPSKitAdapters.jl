# # MPSKitAdapters.jl

# `MPSKitAdapters.jl` provides adapters to convert between the `AbstractMPS` and `AbstractMPO` types of [`MPSKit.jl`](https://github.com/QuantumKitHub/MPSKit.jl) and other tensor libraries like [`ITensorMPS.jl`](https://github.com/ITensor/ITensorMPS.jl) or [`ITensorIMPS.jl`](https://github.com/ManyBodyLab/ITensorIMPS.jl).

# ## Installation

# The package is not yet registered in the Julia general registry. It can be installed trough the package manager with the following command:

# ```julia-repl
# pkg> add git@github.com:ManyBodyLab/MPSKitAdapters.jl.git
# ```

# ## Code Samples

# ```julia
# julia> using MPSKitAdapters, MPSKit, ITensorMPS
# julia> mps_it = random_mps(siteinds("S=1/2", 10); linkdims=10);
# julia> mps_mk = FiniteMPS(mps_it);
# julia> mps_it_reconstructed = MPS(mps_mk);
# julia> mps_mk_reconstructed = FiniteMPS(mps_it_reconstructed);
# julia> mps_it ≈ mps_it_reconstructed
# true 
# julia> mps_mk ≈ mps_mk_reconstructed 
# true
# ```

# ## License

# MPSKitAdapters.jl is licensed under the MIT License. By using or interacting with this software in any way, you agree to the license of this software.
