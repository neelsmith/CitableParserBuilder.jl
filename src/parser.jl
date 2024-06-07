abstract type CitableParser 
end

abstract type AbstractDFParser <: CitableParser end
abstract type AbstractStringParser <: CitableParser end
abstract type AbstractDictParser <: CitableParser end

"""A parser parsing tokens by looking them up in a precomputed dictionary of all recognized forms."""
struct StringParser <: AbstractStringParser
    entries::Vector{AbstractString}

    StringParser
end

"""Write entries to file.
$(SIGNATURES)
"""
function tofile(p::StringParser, f)
    open(f, "w") do io
        write(f, join(p.entries,"\n"))
    end
end


"""A parser parsing tokens by looking them up in a precomputed dictionary of all recognized forms."""
struct DictionaryParser <: AbstractDictParser
    dict    
end



"""Parse token `s` by looking it up in `p.dict`.
$(SIGNATURES)
"""
function parsetoken(s::AbstractString, p::DictionaryParser)::Vector{Analysis}

    results = Vector{Analysis}()
    analyses = p.dict[s]
    for a in analyses
        # An Analysis has five members: a token string value, and four abbreviated URNs, one each for the lexeme, form, rule and stem.
        cols = split(a, "|")
        lex = LexemeUrn(cols[1])
        frm = FormUrn(cols[2])
        rule = RuleUrn(cols[3])
        stem = StemUrn(cols[4])
        push!(results, Analysis(s, lex,frm,rule,stem))
    end
    results
end


"""A parser parsing tokens by looking them up in a precomputed dictionary of all recognized forms."""
struct DFParser <: CitableParser
    df::DataFrame
end

"""Create a `DFParser` from delimited text file.
$(SIGNATURES)
"""
function dfParser(delimitedfile; delimiter = "|")
    @info("Reading delimited-text file $(delimitedfile)...")
    CSV.File(delimitedfile; delim = delimiter) |> DataFrame |> DFParser
end

"""Write dataframe parser to a delimited file.

$(SIGNATURES)
"""
function tofile(dfp::DFParser, outfile; delimiter = "|")
    CSV.write(outfile,dfp.df, delim = delimiter)
end

function parsetoken(s::AbstractString, parser::DFParser; data = nothing)
    @debug("SEARCH FOR $(knormal(s))...")
    resultdf = subset(parser.df, :Token => t -> t .== knormal(s))

    resultarray = Analysis[]

    for r in eachrow(resultdf)
        a =  Analysis(
            r.Token, 
            LexemeUrn(r.Lexeme),
            FormUrn(r.Form),
            StemUrn(r.Stem),
            RuleUrn(r.Rule)
        )
        push!(resultarray, a)
    end
    resultarray
end

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

function orthography(p::T) where {T <: CitableParser}
    msg = string("The orthography function is not implemented for type ", T)
    throw(DomainError(p, msg))
end