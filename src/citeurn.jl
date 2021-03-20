"""
    abbreviate(urn::Cite2Urn)

Constructs an `AbbreviatedUrn` string from a `Cite2Urn`.

Example:
```julia-repl
julia> abbreviate(Cite2Urn("urn:cite2:kanones:lsj.v1:n123"))
"lsj.n123"
```

Example: a pipeline abbreviating a `Cite2Urn` and forming a `LexemeUrn`
from the abbreviated string value.
```julia-repl
julia> Cite2Urn("urn:cite2:kanones:lsj.v1:n123") |> abbreviate |> LexemeUrn
LexemeUrn("lsj", "n123")
```
"""
function abbreviate(urn::Cite2Urn)::String
    string(collectionid(urn), ".", objectcomponent(urn))
end


"""
    expand(au::AbbreviatedUrn, registry::Dict)

Constructs a `Cite2Urn` from an `AbbreviatedUrn`
and a dictionary mapping collection identifiers in 
AbbreviatedUrns's to full `Cite2Urn`s for a
versioned collection.
"""
function expand(au::AbbreviatedUrn, registry::Dict)
    if au.collection in keys(registry)
        Cite2Urn(registry[au.collection] * au.objectid)
    else
        msg = string("In abbreviated urn ", au, ", collection ", au.collection, " not in registry." )
        throw(ArgumentError(msg))
    end
end
