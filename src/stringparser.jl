"""A parser parsing tokens by looking them up in a precomputed dictionary of all recognized forms."""
struct StringParser <: AbstractStringParser
    entries::Vector{AbstractString}
    ortho::OrthographicSystem
    delimiter::AbstractString

    StringParser(
        entries::Vector{AbstractString}, 
        o = simpleAscii(), delim = "|") = new(entries, o, delim)

end

function data(sp::StringParser)::Vector{AbstractString}
    sp.entries
end

function orthography(sp::StringParser)::OrthographicSystem
    sp.ortho
end

function delimiter(sp::StringParser)
    sp.delimiter
end

"""Write entries to file.
$(SIGNATURES)
"""
function tofile(p::StringParser, f)
    open(f, "w") do io
        write(f, join(p.entries,"\n"))
    end
end


"""Constrct a string-backed parser from a dataframe-backed parser.
$(SIGNATURES)
"""
function StringParser(dfp::AbstractDFParser)
    #@info("Convert dfp $(dfp)")
    str = CSV.write(IOBuffer(), dataframe(dfp)) |> take! |> String
    split(str,"\n") |> StringParser
end


"""Instantiate a `StringParser` from a set of analyses read from a string.
$(SIGNATURES)
"""
function stringParser(s, freader::Type{StringReader}; o::OrthographicSystem, delim::AbstractString)
    StringParser(split(s,"\n"), o, delim)
end

"""Instantiate a `StringParser` from a set of analyses read from a file.
$(SIGNATURES)
"""
function stringParser(f, freader::Type{FileReader}; o::OrthographicSystem, delim::AbstractString)
    StringParser(readlines(f), o, delim)
end

"""Instantiate a `StringParser` from a set of analyses read from a URL.
$(SIGNATURES)
"""
function stringParser(u, ureader::Type{UrlReader};
    o::OrthographicSystem, delim::AbstractString)
    tmpfile = Downloads.download(u) 
    sp = StringParser(readlines(tmpfile),o,delim)
    rm(tmpfile)
    sp
end