
function MPSKitPeriodic.InfinitePeriodicMPS(mps::ITensorIMPS.InfiniteMPS, translator=x->x[1])
    AL = PeriodicVector(complex.(MPSKit.MPSTensor.(mps.data.data)), translator)
    return MPSKitPeriodic.InfinitePeriodicMPS(AL)
end

function MPSKitPeriodic.InfinitePeriodicMPS(mps::ITensorIMPS.InfiniteCanonicalMPS, translator=x->x[1])
    AL = PeriodicVector(complex.(MPSKit.MPSTensor.(mps.AL.data.data)), MPSKit.translator)
    return MPSKitPeriodic.InfinitePeriodicMPS(AL, MPSKit.MPSBondTensor(mps.C[end]))
end
