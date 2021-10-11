module CitableParserBuilder
using CitableObject, CitableText, CitableCorpus
using Orthography

using Documenter, DocStringExtensions

import Base: print
import Base: show
import Base: ==

using CitableBase
import CitableBase: CitableTrait
import CitableBase: cex
import CitableBase: urn
import CitableBase: label

# Citable functions from CitableBase 3.x
export urn, label, cex, print
export print, show
export ==

export Analysis, AnalyzedToken, CitableParser
export Stem, Rule

export AbbreviatedUrn
export objectid, collection
export LexemeUrn, FormUrn, StemUrn, RuleUrn

export fstsafe, expand, abbreviate
export readfst
export analyzedtoken_fromcex


export parsetoken, parsewordlist, parselistfromfile, parselistfromurl
export parsepassage, parsecorpus
export coverage, lexical_ambiguity, formal_ambiguity, lexical_frequencies, formal_frequencies

export analyses_relationsblock


include("parser.jl")
include("abbrurn.jl")
include("analysis.jl")
include("analyzed_token.jl")
include("citeurn.jl")
include("types.jl")
include("fstreader.jl")
include("gettysburg.jl")
include("corpus_analyses.jl")

end # module
