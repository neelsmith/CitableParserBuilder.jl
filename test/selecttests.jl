using Pkg
Pkg.activate("..")

import CitableParserBuilder: datasource
using CitableParserBuilder
using CitableBase
using CitableObject, CitableText, CitableCorpus
using Orthography

using CSV, DataFrames
using Test
using TestSetExtensions

 
# Define a minimal concrete parsers for abstract
# types backed by DataFrame or Vector of Strings

struct MinimumDFParser <: AbstractDFParser
    data::DataFrame
end
function datasource(mindfp::MinimumDFParser)
    mindfp.data
end

struct MinimumSParser <: AbstractStringParser
    entries
end
function datasource(minsp::MinimumSParser)
    minsp.entries
end


@testset "All the tests" begin
    println(map(s -> replace(s, r".jl$" => ""), ARGS))
    @includetests map(s -> replace(s, r".jl$" => ""), ARGS)
end
