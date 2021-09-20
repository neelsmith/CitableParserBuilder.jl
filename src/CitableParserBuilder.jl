module CitableParserBuilder
using CitableObject, CitableText, CitableCorpus
using Documenter, DocStringExtensions

import Base: print
import Base: show

using CitableBase
import CitableBase: cex
import CitableBase: urn
import CitableBase: label

# Citable functions from CitableBase 3.0.0
export urn, label, cex, print
export print, show

export Analysis, AnalyzedToken, CitableParser
export Stem, Rule
#export ==
export objectid, collection
export AbbreviatedUrn
export LexemeUrn, FormUrn, StemUrn, RuleUrn

export fstsafe, expand, abbreviate, abbreviation
export readfst
export analysis_fromcex, analyzedtoken_fromcex
export parsetoken, parsewordlist, parselistfromfile, parselistfromurl
export parsenode, parsecorpus


include("parser.jl")
include("abbrurn.jl")
include("analysis.jl")
include("analyzed_token.jl")
include("citeurn.jl")
include("types.jl")
include("fstreader.jl")

end # module
