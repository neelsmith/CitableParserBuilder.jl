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
struct GettysburgParser <: AbstractDFParser
    data::DataFrame
end


function datasource(gp::GettysburgParser)
    gp.data
end

function orthography(gp::GettysburgParser)
    simpleAscii()
end

GETTYSBURG_DICT_URL = "https://raw.githubusercontent.com/neelsmith/CitableCorpusAnalysis.jl/main/test/data/posdict.csv"




function gettysburgDictToParser(dict::Dict; delimiter = ",")
    hdr = join(["Token","Lexeme","Form","Stem","Rule","MToken"], delimiter)
    
    datarows = String[hdr]
    for k in keys(dict)
        row = string(k,delimiter, "gburglex.", k,delimiter, "pennpos.", dict[k],delimiter,"gburgstem.",k,delimiter, "gburgrule.pennid",delimiter,k)
        push!(datarows, row)
    end
    csvsrc = join(datarows,"\n")
    CSV.File(IOBuffer(csvsrc)) |> DataFrame #|> GettysburgParser
end


"""Instantiate a `GettysburgParser` as a dfParser by downloading source dictionary over the internet.
"""
function gettysburgParser() 
   
    downloaded = Downloads.download(CitableParserBuilder.GETTYSBURG_DICT_URL)
    @info("Done loading.")

    dict = CSV.File(downloaded) |> Dict
    rm(downloaded)
    
    gettysburgDictToParser(dict) |> GettysburgParser
end


"""Instatiate `GettysburgParser` as a dfParser
from a local file source.
$(SIGNATURES)
"""
function gettysburgParser(repo::AbstractString; delimiter = ",")
    src = joinpath(repo,"test","data","posdict.csv")

    @debug("Src is $(src)")
    dict = CSV.File(src) |> Dict
    gettysburgDictToParser(dict; delimiter = delimiter) |> GettysburgParser
end
