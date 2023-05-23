module CitableParserBuilder
using CitableBase
using CitableObject, CitableText, CitableCorpus
using Orthography

using Documenter, DocStringExtensions

import Base: show
import Base: ==
import Base: iterate
import Base: eltype
import Base: length

import CitableBase: citabletrait
import CitableBase: urntype
import CitableBase: urn
import CitableBase: label
import CitableBase: objectid

import CitableBase: cextrait
import CitableBase: cex
import CitableBase: fromcex

import CitableBase: citablecollectiontrait


export ParserTrait

export Analysis, analysis
export token, lexemeurn, formurn, stemurn, ruleurn
export tokens
export AnalyzedToken, AnalyzedTokens

export CitableParser
export Stem, Rule

export AnalyzedToken

export AbbreviatedUrn
export objectid, collection
export LexemeUrn, FormUrn, StemUrn, RuleUrn

export expand, abbreviate
export fstsafe, readfst

export lexemes, tokens
export stringsforlexeme, lexemedictionary, passagesforlexeme

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
include("analysis_collection.jl")
include("extractors.jl")



end # module
