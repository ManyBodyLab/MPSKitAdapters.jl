function MPSKit.InfiniteMPOHamiltonian(H::ITensorIMPS.InfiniteMPO)
    return MPSKit.InfiniteMPOHamiltonian(H.data.data)
end

function MPSKit.InfiniteMPOHamiltonian(H::ITensorIMPS.InfiniteCanonicalMPO)
    return MPSKit.InfiniteMPOHamiltonian(H.HL)
end

function MPSKit.InfiniteMPO(H::ITensorIMPS.InfiniteMPO)
    return MPSKit.InfiniteMPO(H.data.data)
end

function MPSKit.InfiniteMPO(H::ITensorIMPS.InfiniteCanonicalMPO)
    return MPSKit.InfiniteMPO(H.HL)
end

function ITensorIMPS.InfiniteMPO(H::MPSKit.InfiniteMPOHamiltonian;
        kwargs...,
    )
    return ITensorIMPS.InfiniteMPO(InfiniteBlockMPO(H; kwargs...))
end

function ITensorIMPS.InfiniteBlockMPO(H::MPSKit.InfiniteMPOHamiltonian;
        ids_sites = itensor_standard_ids(length(H)),
        ids_link_right = itensor_standard_ids(length(H)),
        kwargs...,
    )
    N = length(H)
    ids_link_left = circshift(ids_link_right, 1)

    data = map(eachindex(H)) do i 
        ITensor(H[i], i, N;
            ids=(ids_link_left[i], ids_sites[i], ids_link_right[i]),
            kwargs...
        )
    end

    return ITensorIMPS.reconstruct_translator(ITensorIMPS.InfiniteBlockMPO(data))
end

function ITensorIMPS.InfiniteMPO(H::MPSKit.InfiniteMPO;
        ids_sites = itensor_standard_ids(length(H)),
        ids_link_right = itensor_standard_ids(length(H)),
        kwargs...
    )
    N = length(H)
    ids_link_left = circshift(ids_link_right, 1)

    data = map(eachindex(H)) do i 
        ITensor(H[i], i, N;
            ids=(ids_link_left[i], ids_sites[i], ids_link_right[i]),
            kwargs...
        )
    end
    H = ITensorIMPS.InfiniteMPO(data)
    return ITensorIMPS.reconstruct_translator(H)
end
