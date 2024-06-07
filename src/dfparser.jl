

"""A parser parsing tokens by looking them up in a precomputed data frame of all recognized forms.
$(SIGNATURES)
"""
struct DFParser <: AbstractDFParser
    df::DataFrame
    ortho::OrthographicSystem
end


"""Get `DataFrame` object backing the dataframe parser.

$(SIGNATURES)
"""
function dataframe(dfp::DFParser, ortho = simpleAscii())
    dfp.df
end



"""Get orthographic system for a dataframe parser.

$(SIGNATURES)
"""
function orthography(dfp::DFParser)
    dfp.ortho
end

function parsetoken(s::AbstractString, parser::AbstractDFParser; data = nothing)
    @debug("SEARCH FOR $(s)...")
    resultdf = subset(dataframe(parser), :Token => t -> t .== s)

    resultarray = Analysis[]

    for r in eachrow(resultdf)
        a =  Analysis(
            r.Token, 
            LexemeUrn(r.Lexeme),
            FormUrn(r.Form),
            StemUrn(r.Stem),
            RuleUrn(r.Rule)
        )
        push!(resultarray, a)
    end
    resultarray
end


# All 

"""Create a `DFParser` from delimited text file.
$(SIGNATURES)
"""
function dfParser(delimitedfile, ortho = simpleAscii(); delimiter = "|")
    @info("Reading delimited-text file $(delimitedfile)...")
    CSV.File(delimitedfile; delim = delimiter) |> DataFrame |> DFParser
end


# ... Write this


function parsetoken(dfp::DFParser)
end



"""Write dataframe parser to a delimited file.

$(SIGNATURES)
"""
function tofile(dfp::DFParser, outfile; delimiter = "|")
    CSV.write(outfile, dfp.df, delim = delimiter)
end

function parsetoken(s::AbstractString, parser::DFParser; data = nothing)
    @debug("SEARCH FOR $(knormal(s))...")
    resultdf = subset(parser.df, :Token => t -> t .== knormal(s))

    resultarray = Analysis[]

    for r in eachrow(resultdf)
        a =  Analysis(
            r.Token, 
            LexemeUrn(r.Lexeme),
            FormUrn(r.Form),
            StemUrn(r.Stem),
            RuleUrn(r.Rule)
        )
        push!(resultarray, a)
    end
    resultarray
end