abstract type CitableParser end

abstract type AbstractDFParser <: CitableParser end
abstract type AbstractStringParser <: CitableParser end
abstract type AbstractDictParser <: CitableParser end

"""Catch failure to implement `orthography` function for a
subtype of `CitableParser`.
$(SIGNATURES)
"""
function orthography(p::T) where {T <: CitableParser}
    msg = string("The orthography function is not implemented for type ", T)
    throw(DomainError(p, msg))
end


"""Catch failure to implement `generate` function for a
subtype of `CitableParser`.
$(SIGNATURES)
"""
function generate(lex::LexemeUrn, mform::FormUrn, p::T) where {T <: CitableParser}
    msg = string("The generate function is not implemented for type ", T)
    throw(DomainError(p, msg))
end

"""Catch failure to implement `parsetoken` function for a
subtype of `CitableParser`.
$(SIGNATURES)
"""
#function parsetoken(s::AbstractString, p::T) where {T <: CitableParser}
#    msg = string("The parsetoken function is not implemented for type ", T)
#    throw(DomainError(p, msg))
#end

#=
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
function parsetoken(s::AbstractString, x::T; data = nothing) where {T} 
    parsetoken(CitableTrait(T), s, x; data = data)
end

"""It is an error to invoke the `parsetoken` using types that are not a parser.

$(SIGNATURES)
"""
function parsetoken(::NotAParser, s, x; data = nothing)
    throw(DomainError(x, string("Objects of type ", typeof(x), " are not parsers.")))
end


"""Citable parsers must implement parsetoken.

$(SIGNATURES)
"""
function parsetoken(::CanParseCitable, s, x; data = nothing)
    throw(DomainError(x, string("Please implement the parsetoken function for type ", typeof(x))))
end
=#
