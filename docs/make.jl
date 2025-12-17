using MPSKitAdapters
using Documenter: Documenter, DocMeta, deploydocs, makedocs

DocMeta.setdocmeta!(
    MPSKitAdapters, :DocTestSetup, :(using MPSKitAdapters); recursive = true
)

include("make_index.jl")

makedocs(;
    modules = [MPSKitAdapters],
    authors = "Andreas Feuerpfeil <development@manybodylab.com>",
    sitename = "MPSKitAdapters.jl",
    format = Documenter.HTML(;
        canonical = "https://manybodylab.github.io/MPSKitAdapters.jl",
        edit_link = "main",
        assets = [#"assets/logo.png", 
            "assets/extras.css"],
    ),
    pages = ["Home" => "index.md", "Reference" => "reference.md"],
)

deploydocs(;
    repo = "github.com/ManyBodyLab/MPSKitAdapters.jl", devbranch = "main", push_preview = true
)
