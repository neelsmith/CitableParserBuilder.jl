module CitableParserBuilder
using CitableBase
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

export ParserTrait

export Analysis
export token, lexemeurn, formurn, stemurn, ruleurn
export tokens
export AnalyzedToken
export CitableParser
export Stem, Rule

export AbbreviatedUrn
export objectid, collection
export LexemeUrn, FormUrn, StemUrn, RuleUrn

export expand, abbreviate
export fstsafe, readfst
export analyzedtokens_fromcex
export lexemes, stringsforlexeme, lexemedictionary, passagesforlexeme

export parsetoken, parselist
export parsepassage, parsecorpus

export relationsblock

export delimited


include("parser.jl")
include("abbrurn.jl")
include("analysis.jl")
include("analyzed_token.jl")
include("citeurn.jl")
include("types.jl")
include("fstreader.jl")
include("gettysburg.jl")
include("corpus_analyses.jl")
include("generic.jl")
include("serialization.jl")

end # module
