using ITensors, MPSKit, TensorKit, TensorKitAdapters

itensor_standard_site_type() = "Fermion"
function itensor_standard_ids(N::Integer)
    return [rand(index_id_rng(), ITensors.IDType) for _ in 1:N]
end

function ITensors.ITensor(t::MPSKit.MPSTensor, pos::Integer, N::Integer = -1;
        site_type::AbstractString=itensor_standard_site_type(),
        tags=missing,
        kwargs...,
    )::ITensor
    if ismissing(tags)
        if N == -1
            links = ["Link,l=$(pos-1)", "Site,n=$(pos)", "Link,l=$(pos)"]
        else
            links = ["Link,c=$(cld(pos-1,N)),l=$(mod1(pos-1,N))", "Site,c=1,n=$(mod1(pos,N))", "Link,c=$(cld(pos,N)),l=$(mod1(pos,N))"]
        end
        tags = (site_type * ",") .* links
    end
    return ITensor(t; tags = tags, kwargs...)
end

function ITensors.ITensor(t::MPSKit.MPSBondTensor, pos::Integer, N::Integer = -1;
        site_type::AbstractString=itensor_standard_site_type(),
        tags=missing,
        kwargs...,
    )::ITensor
    if ismissing(tags)
        if N == -1
            links = ["Link,l=$(pos-1)", "Link,l=$(pos)"]
        else
            links = ["Link,c=$(cld(pos,N)),l=$(mod1(pos,N))", "Link,c=$(cld(pos,N)),l=$(mod1(pos,N))"]
        end
        tags = (site_type * ",") .* links
    end
    return ITensor(t; tags = tags, kwargs...)
end

function ITensors.ITensor(t::MPSKit.JordanMPOTensor, pos::Integer, N::Integer = -1;
        site_type::AbstractString=itensor_standard_site_type(),
        tags=missing,
        ids = itensor_standard_ids(3),
        plevs=(0,0,1,0),
        kwargs...,
    )::Array{ITensor}
    if ismissing(tags)
        if N == -1
            links = ["Link,l=$(pos-1)", "Site,n=$(pos)", "Link,l=$(pos)"]
        else
            links = ["Link,c=$(cld(pos-1,N)),l=$(mod1(pos-1,N))", "Site,c=$(cld(pos,N)),n=$(mod1(pos,N))", "Link,c=$(cld(pos,N)),l=$(mod1(pos,N))"]
        end
        tags = (site_type * ",") .* links
    end

    ids = [ids[1],ids[2],ids[2],ids[3]]
    tags = [tags[1],tags[2],tags[2],tags[3]]
    dims = size(t)
    kept_dims=findall(x -> x > 1, dims)
    @assert length(kept_dims) == 2
    dims_new = dims[kept_dims]
    mat = Array{ITensor,length(dims_new)}(undef, dims_new...)
    for i in CartesianIndices(dims)
        i = Tuple(i)
        ## Change arrow direction for siteinds
        intermediate = flip(t[i...],(1,4);inv=true)
        intermediate = TensorKit.permute(intermediate, ((1, 3, 2, 4), ()))

        T = ITensor(intermediate; tags=tags, ids=ids, plevs=plevs, qn_names=qn_names)
        ind = inds(T)

        i_kept = i[kept_dims]
        if i_kept[1] in [1, dims_new[1]]
            T *= ITensors.onehot(dag(ind[1])=>1)
        end
        if i_kept[2] in [1, dims_new[2]]
            T *= ITensors.onehot(dag(ind[4])=>1)
        end
        mat[i_kept...] = T
    end
    return mat
end

function ITensors.ITensor(t::MPSKit.MPOTensor, pos::Integer, N::Integer = -1;
    site_type::AbstractString=itensor_standard_site_type(),
    tags = missing,
    ids = itensor_standard_ids(3),
    plevs = (0,0,1,0),
    kwargs...,
    )::ITensor
    if ismissing(tags)
        if N == -1
            links = ["Link,l=$(pos-1)", "Site,n=$(pos)", "Link,l=$(pos)"]
        else
            links = ["Link,c=$(cld(pos-1,N)),l=$(mod1(pos-1,N))", "Site,c=1,n=$(mod1(pos,N))",  "Link,c=$(cld(pos,N)),l=$(mod1(pos,N))"]
        end
        tags = (site_type * ",") .* links
    end

    ids = [ids[1],ids[2],ids[2],ids[3]]
    tags = [tags[1],tags[2],tags[2],tags[3]]
    
    ## Change arrow direction for siteinds
    intermediate = flip(t,(1,4);inv=true)
    intermediate = TensorKit.permute(intermediate, ((1, 3, 2, 4), ()))

    return ITensor(intermediate; tags=tags, ids=ids, plevs=plevs, kwargs...)
end
