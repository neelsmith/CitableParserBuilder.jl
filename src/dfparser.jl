

"""A parser parsing tokens by looking them up in a precomputed data frame of all recognized forms.
$(SIGNATURES)
"""
struct DFParser <: AbstractDFParser
    df::DataFrame
    ortho::OrthographicSystem

    DFParser(df::DataFrame,   
        ortho::OrthographicSystem = simpleAscii()) = new(df, ortho)
end



"""Get `DataFrame` object backing the dataframe parser.

$(SIGNATURES)
"""
function datasource(dfp::DFParser)::DataFrame
    dfp.df
end

"""Get orthographic system for a dataframe parser.

$(SIGNATURES)
"""
function orthography(dfp::DFParser)
    dfp.ortho
end

function parsetoken(s, parser::AbstractDFParser; data = nothing)
    @debug("SEARCH DF FOR $(s)...")
    df = datasource(parser)
    @debug("df is $(df)")
    resultdf = subset(df, :Token => t -> t .== s)

    resultarray = Analysis[]

    for r in eachrow(resultdf)
        a =  Analysis(
            r.Token, 
            LexemeUrn(r.Lexeme),
            FormUrn(r.Form),
            StemUrn(r.Stem),
            RuleUrn(r.Rule),
            r.MToken,
            r.MTokenID
        )
        push!(resultarray, a)
    end
    resultarray
end



"""Create a `DFParser` from delimited text file.
$(SIGNATURES)
"""
function dfParser(delimitedfile, ortho = simpleAscii(); delimiter = "|")
    @info("Reading delimited-text file $(delimitedfile)...")
    CSV.File(delimitedfile; delim = delimiter) |> DataFrame |> DFParser
end

"""Write dataframe parser to a delimited file.

$(SIGNATURES)
"""
function tofile(dfp::DFParser, outfile; delimiter = "|")
    CSV.write(outfile, dfp.df, delim = delimiter)
end




## 
"""Serializable trait for DF Parser.
"""
struct DFParserCex <: CexTrait end
"""Get serializable trait for DFParser type.
$(SIGNATURES)
"""
function cextrait(::Type{DFParser})
    DFParserCex()
end



"""Compose delimited text string for a DFParser.
$(SIGNATURES)
"""
function cex(dfp::DFParser; delimiter = "|")
    buf = IOBuffer()
    CSV.write(buf, dfp.df; delim = delimiter) 
    take!(buf) |> String
end


"""Create a DFParser from a delimited-text source.
$(SIGNATURES)
"""
function fromcex(trait::DFParserCex, cexsrc::AbstractString, T; 
    delimiter = "|", configuration = nothing, strict = true)
    CSV.File(IOBuffer(cexsrc); delim = delimiter)  |> DataFrame |> DFParser
end
