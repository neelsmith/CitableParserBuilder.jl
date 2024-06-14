
"Value for CexTrait"
struct CexAnalyzedToken <: CexTrait end
"""Define`CexTrait` value for `CitableToken`.
$(SIGNATURES)
"""
function cextrait(::Type{AnalyzedToken})  
    CexAnalyzedToken()
end

"""Serialize an `AnalyzedToken` as delimited text (required for `Citable` interface).

$(SIGNATURES)
Uses abbreviated URNs.  
These can be expanded to full CITE2 URNs when read back with a URN registry,
or the `delimited` function can be used with a URN registry to write full CITE2 URNs.
"""
function cex(at::AnalyzedToken; delimiter = "|")
    if isempty(at.analyses)
        noanalysis = repeat(delimiter, 7)
        cex(at.ctoken.passage; delimiter = delimiter) * noanalysis * string(typeof(at.ctoken.tokentype))
    else
        lines = []
        for analysis in at.analyses

            push!(lines, join([
                cex(at.ctoken.passage; delimiter = delimiter), 
                delimited(analysis; delim = delimiter),
                string(typeof(at.ctoken.tokentype))
                ], delimiter))
        end
        join(lines, "\n")
    end
end


"""Serialize a single `AnalyzedToken` as one or more lines of delimited text.

$(SIGNATURES)
"""
function delimited(at::AnalyzedToken; delim = "|", registry = nothing)
    if isnothing(registry)
        @warn("No registry defined:  serializing AnalyzedToken with abbreviated URN values.")
    end
    @debug("Delimited for analyzedtoken ", at)
    if isempty(at.analyses)
        #noanalysis = "|||||||"
        noanalysis = repeat(delim, 7)
        cex(at.ctoken.passage; delimiter = delim) * noanalysis
    else
        lines = []
        for analysis in at.analyses
            push!(lines, 
            join([
                cex(at.ctoken.passage; delimiter = delim), 
                delimited(analysis; delim = delim, registry = registry),
                string(typeof(at.ctoken.tokentype))
                ], delim))
        end
        join(lines, "\n")
    end
end

"""Serialize a Vector of `AnalyzedToken`s as delimited text.

$(SIGNATURES)
"""
function delimited(v::AbstractVector{AnalyzedToken}; delim = "|", registry = nothing)
    lines = []
    for at in v
        push!(lines, delimited(at; delim = delim, registry = registry))
    end
    join(lines, "\n")
end

#=
function fromcex(trait::CexAnalyzedToken, cexsrc::AbstractString, ::Type{CexAnalyzedToken}; 
    delimiter = "|",  configuration = nothing, strict = true)
    @info("HEY! PARSE ONE AnalyzedToken from cex")
    lines = filter(split(s, "\n")) do ln
        !isempty(ln)
    end

    @debug("Analyzing delimited for ATken")
    map(lines) do s
        parts = split(s, delimiter)
        
        if length(parts) < 9
            @warn("`fromcex` reading AnalyzedTokens: only got $(length(parts)) columns for data line $(s)")
        else
            cp = CitablePassage(CtsUrn(parts[1]), parts[2])
            tokentype = parts[9] * "()" |> Meta.parse |> eval
            ctoken = CitableToken(cp, tokentype)
            alist =  isempty(parts[3]) ? [] : [analysis(join(parts[3:8], "|"))]
            AnalyzedToken(ctoken, alist) 
        end
    end
end

=#

"""Parse a one-line delimited-text representation into an `AnalyzedToken`,
using abbreviated URNs for identifiers.  Note that for a sigle CEX line, the `AnalyzedToken` will have a single `Analysis` in its vector of analyses.

$(SIGNATURES)
"""
#function fromcex(s::AbstractString, ::Type{AnalyzedToken}; delimiter = "|", configuration = nothing, strict = true)
function fromcex(traitvalue::CexAnalyzedToken, cexsrc::AbstractString, T;      
    delimiter = "|", configuration = nothing, strict = true)
    lines = filter(split(cexsrc, "\n")) do ln
        !isempty(ln)
    end

    @info("Analyzing delimited for ATken")
    map(lines) do s
        parts = split(s, delimiter)
        
        if length(parts) < 9
            @warn("`fromcex` reading AnalyzedTokens: only got $(length(parts)) columns for data line $(s)")
        else
            cp = CitablePassage(CtsUrn(parts[1]), parts[2])
            tokentype = parts[9] * "()" |> Meta.parse |> eval
            ctoken = CitableToken(cp, tokentype)
            alist =  isempty(parts[3]) ? [] : [analysis(join(parts[3:8], "|"))]
            AnalyzedToken(ctoken, alist) 
        end
    end
end