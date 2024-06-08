module CitableParserBuilder
using CitableBase
using CitableObject, CitableText, CitableCorpus
using Orthography

using Documenter, DocStringExtensions

using OrderedCollections, StatsBase
using Dictionaries
using DataFrames

import Base: show
import Base: ==
import Base: iterate
import Base: eltype
import Base: length


using CitableBase
import CitableBase: citabletrait
import CitableBase: urntype
import CitableBase: urn
import CitableBase: label
import CitableBase: objectid

import CitableBase: cextrait
import CitableBase: cex
import CitableBase: fromcex

import CitableBase: citablecollectiontrait




export Analysis, analysis
export token, lexemeurn, formurn, stemurn, ruleurn
export tokens
export AnalyzedToken, AnalyzedTokens

export CitableParser
export AbstractStringParser, AbstractDFParser
export datasource, orthography
# TBA: AbstractrDictionaryParser
export Stem, Rule

export StringParser, stringParser, delimiter, dataframe
export DFParser, dfParser


export parsetoken
export parselist
export parsepassage, parsecorpus
export generate

export AnalyzedToken

export AbbreviatedUrn
export objectid, collection
export LexemeUrn, FormUrn, StemUrn, RuleUrn
export lexeme

export expand, abbreviate
export fstsafe, readfst

export tokens, lexemes, forms, stems, rules
export lexemehisto
export stringsforlexeme, lexemedictionary, passagesforlexeme



export relationsblock

export delimited
export urn

include("abbrurn.jl")

include("parser.jl")
include("dfparser.jl")
include("stringparser.jl")
include("dictparser.jl")
include("generators.jl")

include("analysis.jl")
include("citeurn.jl")
include("types.jl")
include("analyzed_token.jl")
include("fstreader.jl")
include("gettysburg.jl")
include("corpus_analyses.jl")
include("generic.jl")
include("analyzedtoken_serialization.jl")
include("analysis_collection.jl")
include("extractors.jl")
include("summarizers.jl")



end # module
