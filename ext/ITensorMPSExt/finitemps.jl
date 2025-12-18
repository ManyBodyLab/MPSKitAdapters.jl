function pad_edges(data)
    length(data) == 0 && return data
    
    data = copy(data)
    dir_left = if length(data)>1
        dir(commonind(data[2], data[1]))
    else
        ITensors.In()
    end
    dir_right = if length(data)>1
        dir(commonind(data[end-1], data[end]))
    else
        ITensors.Out()
    end

    link_left = Index(hasqns(data[1]) ? QN()=>1 : 1; dir = dir_left)
    link_right = Index(hasqns(data[end]) ? QN()=>1 : 1; dir = dir_right)

    data[1] = ITensors.onehot(link_left => 1) * data[1]
    data[end] = data[end] * ITensors.onehot(link_right => 1)
    return data
end
function MPSKit.FiniteMPS(mps::ITensorMPS.MPS)
    return MPSKit.FiniteMPS(pad_edges(mps.data))
end

function ITensorMPS.MPS(mps::MPSKit.FiniteMPS; 
    ids_sites = itensor_standard_ids(length(mps)),
    ids_link_right_AL = itensor_standard_ids(length(mps)),
    kwargs...)
    data = [copy(mps[i]) for i in eachindex(mps)]

    N=length(mps)
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

    return MPS(data; kwargs...)
end
