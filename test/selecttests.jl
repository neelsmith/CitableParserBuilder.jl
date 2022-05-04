using Pkg
Pkg.activate("..")


using CitableParserBuilder
using CitableBase
using CitableObject, CitableText, CitableCorpus
using Orthography

using CSV
using Compat.Test
using TestSetExtensions

@testset "All the tests" begin
    println(map(s -> replace(s, r".jl$" => ""), ARGS))
    @includetests map(s -> replace(s, r".jl$" => ""), ARGS)
end
