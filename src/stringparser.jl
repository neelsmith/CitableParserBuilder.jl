
"""A parser parsing tokens by looking them up in a precomputed dictionary of all recognized forms."""
struct StringParser <: AbstractStringParser
    entries::Vector{AbstractString}
end

"""Write entries to file.
$(SIGNATURES)
"""
function tofile(p::StringParser, f)
    open(f, "w") do io
        write(f, join(p.entries,"\n"))
    end
end

function StringParser(dfp::AbstractDFParser)
    #@info("Convert dfp $(dfp)")
    str = CSV.write(IOBuffer(), dataframe(dfp)) |> take! |> String
    split(str,"\n") |> StringParser
end

