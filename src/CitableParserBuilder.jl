module CitableParserBuilder
using CitableObject


export Analysis
export Stem, Rule
export AbbreviatedUrn
export LexemeUrn, FormUrn, StemUrn, RuleUrn

export fstsafe, expand, abbreviate, abbreviation

include("abbrurn.jl")
include("analysis.jl")
include("citeurn.jl")
include("types.jl")

end # module
