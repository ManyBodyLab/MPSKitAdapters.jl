
function MPSKit.InfinitePeriodicMPS(mps::ITensorIMPS.InfiniteMPS, translator=x->x[1])
    return MPSKitPeriodic.InfinitePeriodicMPS(PeriodicVector(mps.data.data, translator))
end

function MPSKitPeriodic.InfinitePeriodicMPS(mps::ITensorIMPS.InfiniteCanonicalMPS, translator=x->x[1])
    AL = PeriodicVector(mps.AL.data.data, translator)
    return MPSKitPeriodic.InfinitePeriodicMPS(AL, mps.C[end])
end
