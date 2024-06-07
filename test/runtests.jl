using CitableParserBuilder
using CitableBase
using CitableObject, CitableText, CitableCorpus
using Orthography
using CSV
using Test

include("test_abbrexpan.jl")
include("test_analyses.jl")
include("test_analyzedtokens.jl")
include("test_citable.jl")
include("test_collection.jl")
include("test_extractors.jl")

include("test_gettysburg_analysis.jl")
include("test_ioroundtrip.jl")
include("test_parsing.jl")
include("test_types.jl")
include("test_urntypes.jl")



include("deprecated/test_fstencoding.jl")
include("deprecated/test_fstreader.jl")





