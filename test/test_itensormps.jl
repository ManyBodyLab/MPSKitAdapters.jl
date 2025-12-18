using MPSKitAdapters
using Test
using TestExtras
using MPSKit, ITensorMPS
using TensorKit
using LinearAlgebra
using ITensors

@testset "ITensorMPS" begin
    @testset "FiniteMPS" begin 
        for L in [5,10,20]
            for T in [ComplexF32, Float64, ComplexF64]
                max_bond_dimension = ℂ^4
                physical_space = ℂ^2
                mps = FiniteMPS(rand, T, L, physical_space, max_bond_dimension)
                itensor_mps = ITensorMPS.MPS(mps)

                tag = tags(siteinds(itensor_mps)[1])

                @test string(tag[1]) == "Fermion"
                @test string(tag[2]) == "Site"
                @test string(tag[3]) == "n=1"

                tag_link = tags(linkinds(itensor_mps)[1])

                @test string(tag_link[1]) == "Fermion"
                @test string(tag_link[2]) == "Link"
                @test string(tag_link[3]) == "l=1"

                mps_converted = MPSKit.FiniteMPS(itensor_mps)
                @test norm(mps - mps_converted) < 1e-8
                itensor_mps_converted = ITensorMPS.MPS(mps_converted; ids_sites=ITensors.id.(siteinds(itensor_mps)))
                @test norm(itensor_mps - itensor_mps_converted) < 1e-8
            end
        end
    end

    @testset "FiniteMPO" begin 
        for T in [ComplexF32, Float64, ComplexF64]
            S_x = TensorMap(T[0 1; 1 0], ℂ^2 ← ℂ^2)
            S_z = TensorMap(T[1 0; 0 -1], ℂ^2 ← ℂ^2)
            mpo = FiniteMPO(S_x ⊗ S_z ⊗ S_x);
            itensor_mpo = ITensorMPS.MPO(mpo)
            mpo_converted = MPSKit.FiniteMPO(itensor_mpo)
            @test norm(mpo - mpo_converted) < 1e-8
            itensor_mpo_converted = ITensorMPS.MPO(mpo_converted; ids_sites=ITensors.id.(only.(siteinds(itensor_mpo;plev=1))))
            @test norm(itensor_mpo - itensor_mpo_converted) < 1e-8
        end 
    end
end
