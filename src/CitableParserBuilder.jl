module CitableParserBuilder
using CitableBase
using CitableObject, CitableText, CitableCorpus
using Orthography

using Documenter, DocStringExtensions

import Base: show
import Base: ==

import CitableBase: citabletrait
import CitableBase: urntype
import CitableBase: urn
import CitableBase: label
import CitableBase: objectid

import CitableBase: cextrait
import CitableBase: cex
import CitableBase: fromcex

export ParserTrait

export Analysis
export token, lexemeurn, formurn, stemurn, ruleurn
export tokens
export AnalyzedToken

export CitableParser
export Stem, Rule

export AnalyzedToken

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
include("citeurn.jl")
include("types.jl")
include("analyzed_token.jl")
include("fstreader.jl")
include("gettysburg.jl")
include("corpus_analyses.jl")
include("generic.jl")
include("serialization.jl")

end # module
