abstract type CitableParser end



"""Required function to parse a single token with a `CitableParser`.

$(SIGNATURES)
"""
function parsetoken(p::T, t::AbstractString) where {T <: CitableParser}
    @warn("parsetoken function not defined for type ", typeof(p))
    nothing
end


"""Required function to parse a list of tokens with a `CitableParser`.


$(SIGNATURES)
"""
function parsewordlist(p::T, v) where {T <: CitableParser}
    @warn("parsewordlist function not defined for type ", typeof(p))
    nothing
end



"""Required function to parse a list of tokens in a file with a `CitableParser`.

$(SIGNATURES)
"""
function parselistfromfile(p::T, f) where {T <: CitableParser}
    @warn("parselistfromfile function not defined for type ", typeof(p))
    nothing
end



"""Required function to parse a list of tokens at a given url with a `CitableParser`.

$(SIGNATURES)
"""
function parselistfromurl(p::T, u) where {T <: CitableParser}
    @warn("parselistfromurl function not defined for type ", typeof(p))
    nothing
end