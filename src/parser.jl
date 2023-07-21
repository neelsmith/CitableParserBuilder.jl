abstract type CitableParser end

"""The parser trait."""
abstract type ParserTrait end

"""Value for the ParserTrait for compliant parsers."""
struct CanParseCitable <: ParserTrait end

"""Default value for the ParserTrait."""
struct NotAParser <: ParserTrait end

"""Assign default value of ParserTrait to all types."""
ParserTrait(::Type) = NotAParser() 

"""All subtypes of CitableParser must implement this interface."""
ParserTrait(::Type{<: CitableParser}) = CanParseCitable() 

#=
Define delegation for the required function of the CitableParser: parsetoken
=#
"""Delegate to specific functions based on type's citable trait value.

$(SIGNATURES)
"""
function parsetoken(s::AbstractString, x, o::O; data = nothing) where {O <: OrthographicSystem} 
    parsetoken(CitableTrait(T), s, x, o; data)
end

"""It is an error to invoke the `parsetoken` using types that are not a parser.

$(SIGNATURES)
"""
function parsetoken(::NotAParser, s, x, o; data = nothing)
    throw(DomainError(x, string("Objects of type ", typeof(x), " are not parsers.")))
end


"""Citable parsers must implement parsetoken.

$(SIGNATURES)
"""
function parsetoken(::CanParseCitable, s, x, o; data = nothing)
    throw(DomainError(x, string("Please implement the urn function for type ", typeof(x))))
end
