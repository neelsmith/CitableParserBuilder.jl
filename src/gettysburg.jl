# For use in testing and demonstrations: 
# pure-Julia POS tagger for the corpus of all
# extant versions of the Gettysburg address.
# 
# POS values are taken from:
# https://www.ling.upenn.edu/courses/Fall_2003/ling001/penn_treebank_pos.html
#
using CSV, HTTP

"""POS tagger keyed to the text of the Gettysburg address.

- `stringparser` is the parsing function required by the `CitableParser` interface.
- `data` is a dictionary of tokens to form POS tag.
"""
struct GettysburgParser <: CitableParser
    stringparser
    data
end

GETTYSBURG_DICT_URL = "https://raw.githubusercontent.com/neelsmith/CitableCorpusAnalysis.jl/main/test/data/posdict.csv"

"""Instantiate a `GettysburgParser`.
"""
function gettysburgParser() 
    dict = CSV.File(HTTP.get(CitableParserBuilder.GETTYSBURG_DICT_URL).body) |> Dict
    GettysburgParser(parsegburgstring, dict)
end

"""Parse String `s` by looking it up in a given dictionary.
"""
function parsegburgstring(s::AbstractString, data = nothing)
    if isnothing(data) 
        throw(ArgumentError("The GettysburgParser type requires the CitableParser's data parameter in addition to a string token."))
    end
    objid = s in keys(data) ? data[s] : "UNANALYZED"
    if objid == "UNANALYZED"
        @warn("String $s not parsed by Gettysburg parser.") # in $(typeof(data))")
        []
    else
        #@info("Objid ", objid)
        formurn = objid == "." ? FormUrn("gburgform.dot") : FormUrn("gburgform.$objid")
        lexurn = s == "." ? LexemeUrn("gburglex.period") : LexemeUrn("gburglex.$s")
        ruleurn = RuleUrn("gburgrule.all")
        stemurn = StemUrn("gburgstem.all")
        [Analysis(s, lexurn, formurn, stemurn, ruleurn)]
    end
end
