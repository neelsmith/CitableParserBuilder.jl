# For use in testing and demonstrations: 
# pure-Julia POS tagger for the corpus of all
# extant versions of the Gettysburg address.
# 
# POS values are taken from:
# https://www.ling.upenn.edu/courses/Fall_2003/ling001/penn_treebank_pos.html
#
using CSV, Downloads

"""POS tagger keyed to the text of the Gettysburg address. `data` is a dictionary of tokens to form POS tag.
"""
struct GettysburgParser <: CitableParser
    data
end



GETTYSBURG_DICT_URL = "https://raw.githubusercontent.com/neelsmith/CitableCorpusAnalysis.jl/main/test/data/posdict.csv"




function gettsyburgDictToParser(dict::Dict; delimiter = ",")
    hdr = join(["Token","Lexeme","Form","Stem","Rule"], delimiter)
    
    datarows = String[hdr]
    for k in keys(dict)
        row = string(k,delimiter, "gburglex.", k,delimiter, "pennpos.", dict[k],delimiter,"gburgstem.",k,delimiter, "gburgrule.pennid")
        push!(datarows, row)
    end
    csvsrc = join(datarows,"\n")
    CSV.File(IOBuffer(csvsrc)) |> DataFrame
end


"""Instantiate a `GettysburgParser` as a dfParser by downloading source dictionary over the internet.
"""
function gettysburgParser() 
   
    downloaded = Downloads.download(CitableParserBuilder.GETTYSBURG_DICT_URL)

    #downloaded = CSV.File(HTTP.get(CitableParserBuilder.GETTYSBURG_DICT_URL).body) |> Dict
    @info("Done loading.")

    dict = CSV.File(downloaded) |> Dict
    rm(downloaded)
    
    gettsyburgDictToParser(dict; delimiter = delimiter)
    
end


"""Instatiate `GettysburgParser` as a dfParser
from a local file source.
$(SIGNATURES)
"""
function gettysburgParser(repo::AbstractString; delimiter = ",")
    src = joinpath(repo,"test","data","posdict.csv")
    dict = CSV.File(src) |> Dict
    gettsyburgDictToParser(dict; delimiter = delimiter)
end

function orthography(p::GettysburgParser)
    simpleAscii()
end

"""Parse String `s` by looking it up in a given dictionary.
"""
function parsetoken(s::S, parser::GettysburgParser; data = nothing) where {S <: AbstractString}
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
