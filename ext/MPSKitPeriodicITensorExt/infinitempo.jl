function MPSKitPeriodic.InfinitePeriodicMPOHamiltonian(H::ITensorIMPS.InfiniteMPO, translator=x->x[1])
    H = PeriodicVector(H.data.data, translator)
    return MPSKitPeriodic.InfinitePeriodicMPOHamiltonian(H)
end

function MPSKitPeriodic.InfinitePeriodicMPOHamiltonian(H::ITensorIMPS.InfiniteCanonicalMPO, translator=x->x[1])
    return MPSKitPeriodic.InfinitePeriodicMPOHamiltonian(H.HL, translator)
end

function MPSKitPeriodic.InfinitePeriodicMPO(H::ITensorIMPS.InfiniteMPO, translator=x->x[1])
    H = PeriodicVector(H.data.data, translator)
    return MPSKitPeriodic.InfinitePeriodicMPO(H)
end

function MPSKitPeriodic.InfinitePeriodicMPO(H::ITensorIMPS.InfiniteCanonicalMPO, translator=x->x[1])
    H = PeriodicVector(H.HL.data.data, translator)
    return MPSKitPeriodic.InfinitePeriodicMPO(H)
end
