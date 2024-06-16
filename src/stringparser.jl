"""A parser parsing tokens by looking them up in a precomputed dictionary of all recognized forms."""
struct StringParser <: AbstractStringParser
    entries #::Vector{AbstractString}
    ortho::OrthographicSystem
    delimiter::AbstractString

    StringParser(
        entries, #::Vector{AbstractString}, 
        ortho::OrthographicSystem = simpleAscii(), delim::AbstractString = "|") = new(entries, ortho, delim)

end

function datasource(sp::StringParser)#::Vector{AbstractString}
    sp.entries
end

function orthography(sp::StringParser)::OrthographicSystem
    sp.ortho
end

function delimiter(sp::StringParser)
    sp.delimiter
end

#=
"""Create an `Analysis` from line of delimited text.
$(SIGNATURES)
"""
function fromline(s::AbstractString; delimiter = "|")
    pieces = split(s,delimiter)
    Analysis(
        pieces[1], 
        LexemeUrn(pieces[2]),
        FormUrn(pieces[3]),
        StemUrn(pieces[4]),
        RuleUrn(pieces[5])
    )
end
=#



"""Parse a single token using `parser`.
$(SIGNATURES)
"""
function parsetoken(s::AbstractString, parser::AbstractStringParser)
    ptrn = s * delimiter(parser)
    @debug("Looking for $(s) in parser data")
    matches = filter(ln -> startswith(ln, ptrn), datasource(parser))
    map(ln -> cex(ln), matches)
end



"""Write entries to file.
$(SIGNATURES)
"""
function tofile(p::StringParser, f; addheader = false)
    hdr = join(["Token","Lexeme","Form","Stem","Rule"], delimiter(p))
    content = addheader ? hdr * "\n" * join(p.entries,"\n") : join(p.entries,"\n")
    open(f, "w") do io
        write(f, content)
    end
end


"""Construct a string-backed parser from a dataframe.
$(SIGNATURES)
"""
function stringParser(df::DataFrame, ortho = simpleAscii(), delim = "|")
    strlist = CSV.write(IOBuffer(), df; delim = delim) |> take! |> String
    StringParser(split(strlist,"\n"), ortho, delim)
end

"""Construct a string-backed parser from a dataframe-backed parser.
$(SIGNATURES)
"""
function StringParser(dfp::AbstractDFParser; delim = "|")
    @debug("Convert dfp $(dfp)")
    stringParser(datasource(dfp), orthography(dfp), delim)
end


"""Instantiate a `StringParser` from a set of analyses read from a string.
$(SIGNATURES)
"""
function stringParser(s, freader::Type{StringReader}; ortho::OrthographicSystem, delim::AbstractString)
    StringParser(split(s,"\n"), ortho, delim)
end

"""Instantiate a `StringParser` from a set of analyses read from a file.
$(SIGNATURES)
"""
function stringParser(f, freader::Type{FileReader}; o::OrthographicSystem = simpleAscii(), delim::AbstractString = "|")
    StringParser(readlines(f), o, delim)
end

"""Instantiate a `StringParser` from a set of analyses read from a URL.
$(SIGNATURES)
"""
function stringParser(u, ureader::Type{UrlReader};
    o::OrthographicSystem = simpleAscii(), delim::AbstractString = "|")
    tmpfile = Downloads.download(u) 
    sp = StringParser(readlines(tmpfile),o,delim)
    rm(tmpfile)
    sp
end

function dataframe(sp::StringParser)
    CSV.File(IOBuffer( join(datasource(sp),"\n")) , delim = "|") |> DataFrame
end


## 
struct StringParserCex <: CexTrait end
function cextrait(::Type{StringParser})
    StringParserCex()
end



function cex(sp::StringParser; delimiter = "|")
    join(sp.entries, "\n")
end


function fromcex(trait::StringParserCex, cexsrc::AbstractString, T; 
    delimiter = "|", configuration = nothing, strict = true)
    split(cexsrc,"\n") |> StringParser
end
    