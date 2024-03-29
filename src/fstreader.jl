"""Read SFST output from file `f`, and parse into a dictionary keying
tokens to a (possibly empty) array of SFST strings.

$(SIGNATURES)

"""
function  readfst(f)
    analyses = Dict()
    currenttoken = ""
    currentfst = []
    for ln in eachline(f)
        if startswith(ln, "no result")
            analyses[currenttoken] = []
        elseif startswith(ln, "<u>")
            push!(currentfst, ln)
        else            
            analyses[currenttoken] = currentfst
            currenttoken = replace(ln, "> " => "")
            currentfst = []
        end
    end
    analyses
end


"""Compose SFST representation of an `AbbreviatedUrn`.

$(SIGNATURES)

Example:

```julia-repl
julia> LexemeUrn("lexicon.lex123") |> fstsafe
"<u>lexicon\\.lex123</u>"
```
"""
function fstsafe(au::AbbreviatedUrn)
    string("<u>", protectreserved(au.collection), raw"\.", protectreserved(au.objectid), "</u>")
end

"""Escape characters reserved for SFST syntax.


$(SIGNATURES)
"""
function protectreserved(s)
    underscores = replace(s, "_" => raw"\_")
    periods = replace(underscores,"." => raw"\.")
    periods
end
