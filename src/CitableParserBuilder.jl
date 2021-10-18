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


export ParserTrait

export Analysis, AnalyzedToken, CitableParser
export Stem, Rule

export AbbreviatedUrn
export objectid, collection
export LexemeUrn, FormUrn, StemUrn, RuleUrn

export fstsafe, expand, abbreviate
export readfst
export analyzedtokens_fromcex
export lexemes, stringsforlexeme, lexemedictionary


export parsetoken, parsewordlist, parselistfromfile, parselistfromurl
export parsepassage, parsecorpus, parsedocument
export coverage, lexical_ambiguity, formal_ambiguity, lexical_frequencies, formal_frequencies

export analyses_relationsblock

export delimited

export TextCounts, count_analyses
export TextProfile, profile


export  vocabulary_density, token_coverage, vocabulary_coverage, lexical_density, form_density_incorpus, form_density_invocabulary, form_density_inlexicon, formal_ambiguity, lexical_ambiguity



include("parser.jl")
include("textcounts.jl")
include("textprofile.jl")
include("profiling.jl")
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
