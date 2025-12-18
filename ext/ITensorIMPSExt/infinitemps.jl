
function MPSKit.InfiniteMPS(mps::ITensorIMPS.InfiniteMPS)
    return MPSKit.InfiniteMPS(mps.data.data)
end

function MPSKit.InfiniteMPS(mps::ITensorIMPS.InfiniteCanonicalMPS)
    return MPSKit.InfiniteMPS(mps.AL.data.data, mps.C[end])
end

function ITensorIMPS.InfiniteCanonicalMPS(mps::MPSKit.InfiniteMPS;
        ids_sites = itensor_standard_ids(length(mps)),
        ids_link_right_AL = itensor_standard_ids(length(mps)),
        ids_link_right_AR = itensor_standard_ids(length(mps)),
        kwargs...
    )

    N=length(mps)
    ids_link_left_AL = circshift(ids_link_right_AL, 1)

    AL = map(1:N) do i 
        ids = (ids_link_left_AL[i], ids_sites[i], ids_link_right_AL[i])
        ITensors.ITensor(mps.AL[i], i, N;
            ids=ids,
            kwargs...,
        )
    end

    ids_link_left_AR = circshift(ids_link_right_AR, 1)

    AR = map(1:N) do i 
        ids = (ids_link_left_AR[i], ids_sites[i], ids_link_right_AR[i])
        ITensors.ITensor(mps.AR[i], i, N;
            ids=ids,
            kwargs...,
        )
    end

    C = map(1:N) do i 
        ids = [ids_link_right_AL[i], ids_link_left_AR[mod1(i+1,N)]]
        ITensors.ITensor(mps.C[i], i, N;
            ids=ids,
            kwargs...,
        )
    end

    ψ = ITensorIMPS.InfiniteCanonicalMPS(
        ITensorIMPS.InfiniteMPS(AL), 
        ITensorIMPS.InfiniteMPS(C), 
        ITensorIMPS.InfiniteMPS(AR)
    )

    return ITensorIMPS.reconstruct_translator(ψ)
end
