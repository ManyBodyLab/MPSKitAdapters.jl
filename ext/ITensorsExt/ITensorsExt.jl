module ITensorsExt

using ITensors, MPSKit, TensorKit, TensorKitAdapters
import TensorKit: ⊗, space
import MPSKit: MPOTensor, JordanMPOTensor, MPSTensor, MPSBondTensor,
               InfiniteMPO, InfiniteMPOHamiltonian, InfiniteMPS
using BlockTensorKit: SparseBlockTensorMap, SumSpace

include("itensor_utility.jl")
include("mpskit_utility.jl")

end
