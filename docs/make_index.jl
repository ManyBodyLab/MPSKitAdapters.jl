using Literate: Literate
using MPSKitAdapters

Literate.markdown(
    joinpath(pkgdir(MPSKitAdapters), "docs", "files", "README.jl"),
    joinpath(pkgdir(MPSKitAdapters), "docs", "src");
    flavor = Literate.DocumenterFlavor(),
    name = "index",
)
