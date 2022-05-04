# For use in testing and demonstrations: 
# pure-Julia POS tagger for the corpus of all
# extant versions of the Gettysburg address.
# 
# POS values are taken from:
# https://www.ling.upenn.edu/courses/Fall_2003/ling001/penn_treebank_pos.html
#
using CSV, HTTP

"""POS tagger keyed to the text of the Gettysburg address. `data` is a dictionary of tokens to form POS tag.
"""
struct GettysburgParser <: CitableParser
    data
end
# parsegburgstring


GETTYSBURG_DICT_URL = "https://raw.githubusercontent.com/neelsmith/CitableCorpusAnalysis.jl/main/test/data/posdict.csv"

"""Instantiate a `GettysburgParser`.
"""
function gettysburgParser(; dict = nothing) 
    if isnothing(dict)
        @info("Loading dictionary over the internet...")
        downloaded = CSV.File(HTTP.get(CitableParserBuilder.GETTYSBURG_DICT_URL).body) |> Dict
        @info("Done loading.")
        GettysburgParser(downloaded)
    else
        GettysburgParser(dict)
    end
end

"""Parse String `s` by looking it up in a given dictionary.
"""
function parsetoken(s::AbstractString, parser::GettysburgParser; data = nothing)
    if isnothing(data) 
        throw(ArgumentError("The GettysburgParser type requires the CitableParser's data parameter in addition to a string token."))
    end
    objid = s in keys(data) ? data[s] : "UNANALYZED"
    if objid == "UNANALYZED"
        @warn("String \"$s\" not parsed by Gettysburg parser.") # in $(typeof(data))")
        []
    else
        @debug("Objid ", objid)
        formurn = objid == "." ? FormUrn("gburgform.dot") : FormUrn("gburgform.$objid")
        lexurn = s == "." ? LexemeUrn("gburglex.period") : LexemeUrn("gburglex.$s")
        ruleurn = RuleUrn("gburgrule.all")
        stemurn = StemUrn("gburgstem.all")
        [Analysis(s, lexurn, formurn, stemurn, ruleurn)]
    end
end
