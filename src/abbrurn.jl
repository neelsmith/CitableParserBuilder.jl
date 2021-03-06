"Short form of a Cite2Urn containing only collection and object ID."
abstract type AbbreviatedUrn end

"""Equality function for all subtypes of `AbbreviatedUrn`.

$(SIGNATURES)
"""
function Base.:(==)(x::T, y::T)  where {T <: AbbreviatedUrn}
    collection(x) == collection(y) && objectid(x) == objectid(y)

end


"""Default implementation of function to find collection value of `AbbreviatedUrn`.

$(SIGNATURES)
"""
function collection(au::T) where {T <: AbbreviatedUrn}
    # default to looking for a member!
    au.collection
end


"""Default implementation of function to find collection value of `AbbreviatedUrn`.

$(SIGNATURES)
"""
function objectid(au::T) where {T <: AbbreviatedUrn}
    # default to looking for a member!
    au.objectid
end


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


"""Compose SFST representation of an `AbbreviatedUrn`.

$(SIGNATURES)

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


"""Create string abbreviation for an `AbbreviatedUrn`.

$(SIGNATURES)
"""
function abbreviation(au)
    string(au.collection,".", au.objectid)
end
