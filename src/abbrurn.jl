"Short form of a Cite2Urn containing only collection and object ID."
abstract type AbbreviatedUrn end

"""Override `Base.==` for `AbbreviatedUrn`.

$(SIGNATURES)
"""
function ==(au1::T, au2::T) where {T <: AbbreviatedUrn}
    collection(au1) == collection(au2) && objectid(au1) == objectid(au2)

end

"""Override `Base.show` for `AbbreviatedUrn`.

$(SIGNATURES)
"""
function show(io::IO, au::T) where {T <: AbbreviatedUrn}
    print(io, join([collection(au), objectid(au)], "."))
end


"""Default implementation of function to find the collection value of an `AbbreviatedUrn`.

$(SIGNATURES)
"""
function collection(au::T) where {T <: AbbreviatedUrn}
    # default to looking for a member!
    au.collection
end

"""Default implementation of function to find the object identifier of `AbbreviatedUrn`.

$(SIGNATURES)
"""
function objectid(au::T) where {T <: AbbreviatedUrn}
    # default to looking for a member!
    au.objectid
end

"""Override `Base.print` for `AbbreviatedUrn`.

$(SIGNATURES)
"""
function print(io::IO, au::T) where {T <: AbbreviatedUrn}
    print(io, join([collection(au), objectid(au)], "."))
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

