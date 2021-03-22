module CitableParserBuilder
using CitableObject

export AbbreviatedUrn


export LexemeUrn
export StemUrn
export RuleUrn
export FormUrn
export Analysis

export fstsafe, expand, abbreviate, abbreviation



include("abbrurn.jl")
include("analysis.jl")
include("citeurn.jl")

end # module
