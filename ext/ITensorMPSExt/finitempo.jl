function MPSKit.FiniteMPOHamiltonian(H::ITensorMPS.MPO)
    return MPSKit.FiniteMPOHamiltonian(pad_edges(H.data))
end

function MPSKit.FiniteMPO(H::ITensorMPS.MPO)
    return MPSKit.FiniteMPO(pad_edges(H.data))
end

function ITensorMPS.MPO(mpo::MPSKit.FiniteMPO; 
        ids_sites = itensor_standard_ids(length(mpo)),
        ids_link_right_AL = itensor_standard_ids(length(mpo)),
        kwargs...
    )
    data = [copy(mpo[i]) for i in eachindex(mpo)]

    N = length(mpo)
    push!(ids_link_right_AL, only(itensor_standard_ids(1)))

    data = map(eachindex(data)) do i 
        ids = (ids_link_right_AL[i], ids_sites[i], ids_link_right_AL[i+1])
        ITensors.ITensor(data[i], i;
            ids=ids,
        )
    end

    ind_left_edge = only(filter(x->ITensors.id(x)==ids_link_right_AL[1],inds(data[1])))
    ind_right_edge = only(filter(x->ITensors.id(x)==ids_link_right_AL[end],inds(data[end])))
    data[1] *= ITensors.onehot(dag(ind_left_edge) => 1)
    data[end] *= ITensors.onehot(dag(ind_right_edge) => 1)

    if length(data)>1
        @assert !isempty(commoninds(data[1],data[2]))
        @assert !isempty(commoninds(data[end-1],data[end]))
    end

    return ITensorMPS.permute(ITensorMPS.MPO(data; kwargs...), (linkind, siteinds, linkind))
end
