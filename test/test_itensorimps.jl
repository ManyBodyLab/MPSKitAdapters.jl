using MPSKitAdapters
using Test
using TestExtras
using MPSKit, ITensorIMPS
using ITensorMPS
using TensorKit
using LinearAlgebra
using ITensors

@testset "ITensorIMPS" begin
    @testset "InfiniteMPS" begin 
        for T in [ComplexF32, Float64, ComplexF64]
            data = [rand(T, ℂ^4 ⊗ ℂ^2  ← ℂ^4) for _ in 1:2]
            mps = MPSKit.InfiniteMPS(data)
            
            itensor_mps = ITensorIMPS.InfiniteCanonicalMPS(mps)

            tag = tags(siteinds(itensor_mps)[1])

            @test string(tag[1]) == "Fermion"
            @test string(tag[2]) == "Site"
            @test string(tag[3]) == "c=1"
            @test string(tag[4]) == "n=1"

            tag_link = tags(linkinds(only, itensor_mps)[1])

            @test string(tag_link[1]) == "Fermion"
            @test string(tag_link[2]) == "Link"
            @test string(tag_link[3]) == "c=1"
            @test string(tag_link[4]) == "l=1"

            mps_converted = MPSKit.InfiniteMPS(itensor_mps)
            @test dot(mps, mps_converted) ≈ 1.0 atol=1e-8
            itensor_mps_converted = ITensorIMPS.InfiniteCanonicalMPS(mps_converted; ids_sites=ITensors.id.(siteinds(itensor_mps)))
            @test dot(itensor_mps, itensor_mps_converted) ≈ 1.0 atol=1e-8
        end
    end

    @testset "FiniteMPO" begin 
        for T in [ComplexF32, Float64, ComplexF64]
            S_x = TensorMap(T[0 1; 1 0], ℂ^2 ← ℂ^2)
            S_z = TensorMap(T[1 0; 0 -1], ℂ^2 ← ℂ^2)
            mpo = FiniteMPO(S_x ⊗ S_z ⊗ S_x);
            mpo = MPSKit.InfiniteMPO(mpo[1:2])
            itensor_mpo = ITensorIMPS.InfiniteMPO(mpo)
            mpo_converted = MPSKit.InfiniteMPO(itensor_mpo)
            @test dot(mpo, mpo_converted) ≈ dot(mpo, mpo) atol=1e-8
            itensor_mpo_converted = ITensorIMPS.InfiniteMPO(mpo_converted; ids_sites=ITensors.id.(siteinds(itensor_mpo)))
            @test norm(ITensors.array(itensor_mpo_converted[1])-ITensors.array(itensor_mpo[1])) ≈ 0.0 atol=1e-8
            @test norm(ITensors.array(itensor_mpo_converted[2])-ITensors.array(itensor_mpo[2])) ≈ 0.0 atol=1e-8
        end 
    end
end
