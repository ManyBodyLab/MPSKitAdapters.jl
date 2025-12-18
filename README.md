<!-- <img src="./docs/src/assets/logo_readme.svg" width="150"> -->

# MPSKitAdapters.jl

| **Documentation** | **Downloads** |
|:-----------------:|:-------------:|
| [![][docs-stable-img]][docs-stable-url] [![][docs-dev-img]][docs-dev-url] | [![Downloads][downloads-img]][downloads-url]

<!-- | **Documentation** | **Digital Object Identifier** | **Citation** | **Downloads** |
|:-----------------:|:-----------------------------:|:------------:|:-------------:|
| [![][docs-stable-img]][docs-stable-url] [![][docs-dev-img]][docs-dev-url] | [![DOI][doi-img]][doi-url] | | [![Downloads][downloads-img]][downloads-url] -->

| **Build Status** |**Coverage** | **Style Guide** | **Quality assurance** |
|:----------------:|:------------:|:---------------:|:---------------------:|
| [![CI][ci-img]][ci-url] | [![Codecov][codecov-img]][codecov-url] | [![code style: runic][codestyle-img]][codestyle-url] | [![Aqua QA][aqua-img]][aqua-url] |

[docs-stable-img]: https://img.shields.io/badge/docs-stable-blue.svg
[docs-stable-url]: https://manybodylab.github.io/MPSKitAdapters.jl/stable

[docs-dev-img]: https://img.shields.io/badge/docs-dev-blue.svg
[docs-dev-url]: https://manybodylab.github.io/MPSKitAdapters.jl/dev

[doi-img]: https://zenodo.org/badge/DOI/
[doi-url]: https://doi.org/

[downloads-img]: https://img.shields.io/badge/dynamic/json?url=http%3A%2F%2Fjuliapkgstats.com%2Fapi%2Fv1%2Ftotal_downloads%2FMPSKitAdapters&query=total_requests&label=Downloads
[downloads-url]: http://juliapkgstats.com/pkg/MPSKitAdapters

[ci-img]: https://github.com/ManyBodyLab/MPSKitAdapters.jl/actions/workflows/Tests.yml/badge.svg
[ci-url]: https://github.com/ManyBodyLab/MPSKitAdapters.jl/actions/workflows/Tests.yml

[pkgeval-img]: https://JuliaCI.github.io/NanosoldierReports/pkgeval_badges/M/MPSKitAdapters.svg
[pkgeval-url]: https://JuliaCI.github.io/NanosoldierReports/pkgeval_badges/M/MPSKitAdapters.html

[codecov-img]: https://codecov.io/gh/ManyBodyLab/MPSKitAdapters.jl/branch/main/graph/badge.svg
[codecov-url]: https://codecov.io/gh/ManyBodyLab/MPSKitAdapters.jl

[aqua-img]: https://raw.githubusercontent.com/JuliaTesting/Aqua.jl/master/badge.svg
[aqua-url]: https://github.com/JuliaTesting/Aqua.jl

[codestyle-img]: https://img.shields.io/badge/code_style-%E1%9A%B1%E1%9A%A2%E1%9A%BE%E1%9B%81%E1%9A%B2-black
[codestyle-url]: https://github.com/fredrikekre/Runic.jl

`MPSKitAdapters.jl` provides adapters to convert between the `AbstractMPS` and `AbstractMPO` types of [`MPSKit.jl`](https://github.com/QuantumKitHub/MPSKit.jl) and other tensor libraries like [`ITensorMPS.jl`](https://github.com/ITensor/ITensorMPS.jl) or [`ITensorIMPS.jl`](https://github.com/ManyBodyLab/ITensorIMPS.jl).

## Installation

The package is not yet registered in the Julia general registry. It can be installed trough the package manager with the following command:

```julia-repl
pkg> add git@github.com:ManyBodyLab/MPSKitAdapters.jl.git
```

## Code Samples

```julia
julia> using MPSKitAdapters, MPSKit, ITensorMPS
julia> mps_it = random_mps(siteinds("S=1/2", 10); linkdims=10);
julia> mps_mk = FiniteMPS(mps_it);
julia> mps_it_reconstructed = MPS(mps_mk);
julia> mps_mk_reconstructed = FiniteMPS(mps_it_reconstructed);
julia> mps_it ≈ mps_it_reconstructed
true 
julia> mps_mk ≈ mps_mk_reconstructed 
true
```

## License

MPSKitAdapters.jl is licensed under the [MIT License](LICENSE). By using or interacting with this software in any way, you agree to the license of this software.
