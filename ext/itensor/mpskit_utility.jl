using ITensors, MPSKit, TensorKit, TensorKitAdapters
import TensorKit: ⊗
import MPSKit: MPOTensor, JordanMPOTensor, MPSTensor, MPSBondTensor, InfiniteMPO, InfiniteMPOHamiltonian, InfiniteMPS

using BlockTensorKit: SparseBlockTensorMap, SumSpace

function mpoham_blockspace(V)
    S = spacetype(V)
    return SumSpace(
        oneunit(S),
        S(c => isone(c) ? TensorKit.dim(V, c) - 2 : TensorKit.dim(V, c) for c in sectors(V)),
        oneunit(S)
    )
end

function MPSKit.MPOTensor(Osrc::ITensors.ITensor)
    O_tm = TensorKit.permute(TensorMap(Osrc), ((1, 3), (2, 4)))

    O_tm = flip(O_tm, 3)
    # canonicalize arrows
    isdual(left_virtualspace(O_tm)) && (O_tm = flip(O_tm, 1))
    isdual(right_virtualspace(O_tm)) && (O_tm = flip(O_tm, 4))
    return O_tm
end

function MPSKit.JordanMPOTensor(Osrc::ITensors.ITensor)
    O_tm = MPSKit.MPOTensor(Osrc)
    # convert to blocktensor
    P = physicalspace(O_tm)
    V_left = left_virtualspace(O_tm)
    V_right = right_virtualspace(O_tm)
    W_space = mpoham_blockspace(V_left) ⊗ P ← P ⊗ mpoham_blockspace(V_right)
    W = SparseBlockTensorMap(O_tm, W_space)

    # sanity checks
    τ = BraidingTensor{scalartype(W), spacetype(W)}(P, oneunit(spacetype(W)))
    @assert W[1, 1, 1, 1] ≈ τ "input MPO does not have the correct (1, 1) identity block"
    @assert W[3, 1, 1, 3] ≈ τ "input MPO does not have the correct (3, 3) identity block"

    # construct JordanMPOTensor
    J = MPSKit.JordanMPOTensor{scalartype(W), spacetype(W)}(undef, W_space)
    J[2, 1, 1, 2] = W[2, 1, 1, 2]
    J[2, 1, 1, 3] = W[2, 1, 1, 3]
    J[1, 1, 1, 2] = W[1, 1, 1, 2]
    J[1, 1, 1, 3] = W[1, 1, 1, 3]

    return J
end

MPSKit.InfiniteMPOHamiltonian(O::AbstractVector{<:ITensors.ITensor}) =
    MPSKit.InfiniteMPOHamiltonian(MPSKit.JordanMPOTensor.(O))

MPSKit.InfiniteMPO(O::AbstractVector{<:ITensors.ITensor}) =
    MPSKit.InfiniteMPO(MPSKit.MPOTensor.(O))

MPSKit.FiniteMPOHamiltonian(O::AbstractVector{<:ITensors.ITensor}) = 
    MPSKit.FiniteMPOHamiltonian(MPSKit.JordanMPOTensor.(O))

MPSKit.FiniteMPO(O::AbstractVector{<:ITensors.ITensor}) = MPSKit.FiniteMPO(MPSKit.MPOTensor.(O))


function MPSKit.MPSTensor(A::ITensors.ITensor)
    A_tm = TensorKit.permute(TensorMap(A), ((1, 2), (3,)))

    # canonicalize arrows
    isdual(left_virtualspace(A_tm)) && (A_tm = flip(A_tm, 1))
    isdual(right_virtualspace(A_tm)) && (A_tm = flip(A_tm, 3))

    return A_tm
end

MPSKit.InfiniteMPS(A::AbstractVector{<:ITensors.ITensor}) = MPSKit.InfiniteMPS(MPSKit.MPSTensor.(A))

function MPSKit.MPSBondTensor(C::ITensors.ITensor)
    C_tm = TensorKit.permute(TensorMap(C), ((1,), (2,)))

    # canonicalize arrows
    isdual(left_virtualspace(C_tm)) && (C_tm = flip(C_tm, 1))
    isdual(right_virtualspace(C_tm)) && (C_tm = flip(C_tm, 2))

    return complex(C_tm)
end

MPSKit.InfiniteMPS(A::AbstractVector{<:ITensors.ITensor}, C::ITensors.ITensor) =
    MPSKit.InfiniteMPS(complex.(MPSKit.MPSTensor.(A)), MPSKit.MPSBondTensor(C))

MPSKit.FiniteMPS(A::AbstractVector{<:ITensors.ITensor}) = MPSKit.FiniteMPS(MPSKit.MPSTensor.(A))
