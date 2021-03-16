"""Constructs an `AbbreviatedUrn` string from a `Cite2Urn`.
"""
function abbreviate(urn::Cite2Urn)::String
    string(collectionid(urn), ".", objectcomponent(urn))
end


"""Constructs a `Cite2Urn` from an `AbbreviatedUrn`
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
