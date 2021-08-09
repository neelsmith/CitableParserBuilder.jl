module CitableParserBuilder
using CitableObject, CitableText
using Documenter, DocStringExtensions

export Analysis, AnalyzedToken, CitableParser
export Stem, Rule
export ==
export objectid, collection
export AbbreviatedUrn
export LexemeUrn, FormUrn, StemUrn, RuleUrn

export fstsafe, expand, abbreviate, abbreviation
export readfst
export cex
export parsetoken, parsewordlist, parselistfromfile, parselistfromurl


include("parser.jl")
include("abbrurn.jl")
include("analysis.jl")
include("citeurn.jl")
include("types.jl")
include("fstreader.jl")

end # module
