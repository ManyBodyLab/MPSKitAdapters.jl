using MPSKitAdapters
using Aqua: Aqua
using Test
using TestExtras

@testset "Code quality (Aqua.jl)" begin
    Aqua.test_all(MPSKitAdapters)
end
