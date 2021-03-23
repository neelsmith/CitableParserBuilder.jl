"Short form of a Cite2Urn containing only collection and object ID."
abstract type AbbreviatedUrn end

"Abbreviated URN for a morphological stem."
struct StemUrn <: AbbreviatedUrn
    collection::AbstractString
    objectid::AbstractString
    StemUrn(s) = begin
        parts = split(s,".")
        if length(parts) == 2
            new(parts[1], parts[2])
        else
            throw(ArgumentError("AbbreviatedUrn: invalid syntax: $(s)"))
        end
    end
end

"Abbreviated URN for rule."
struct RuleUrn <: AbbreviatedUrn
    collection::AbstractString
    objectid::AbstractString
    RuleUrn(s) = begin
        parts = split(s,".")
        if length(parts) == 2
            new(parts[1], parts[2])
        else
            throw(ArgumentError("AbbreviatedUrn: invalid syntax: $(s)"))
        end
    end
end


"Abbreviated URN for a lexeme."
struct LexemeUrn <: AbbreviatedUrn
    collection::AbstractString
    objectid::AbstractString
    LexemeUrn(s) = begin
        parts = split(s,".")
        if length(parts) == 2
            new(parts[1], parts[2])
        else
            throw(ArgumentError("AbbreviatedUrn: invalid syntax: $(s)"))
        end
    end
end

"""
Abbreviated URN for a morphological form.
"""
struct FormUrn <: AbbreviatedUrn
    collection::AbstractString
    objectid::AbstractString
    FormUrn(s) = begin
        parts = split(s,".")
        if length(parts) == 2
            new(parts[1], parts[2])
        else
            throw(ArgumentError("AbbreviatedUrn: invalid syntax: $(s)"))
        end
    end
end


"""
    fstsafe(au::AbbreviatedUrn)

Compose SFST representation of an `AbbreviatedUrn`.

Example:

```julia-repl
julia> LexemeUrn("lexicon.lex123") |> fstsafe
"<u>lexicon\\.lex123</u>"
```
"""
function fstsafe(au::AbbreviatedUrn)
    string("<u>", protectunderscore(au.collection), raw"\.", protectunderscore(au.objectid), "</u>")
end

function protectunderscore(s)
    replace(s, "_" => raw"\_")
end

function abbreviation(au)
    string(protectunderscore(au.collection),".", protectunderscore(au.objectid))
end
