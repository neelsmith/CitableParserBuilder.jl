"Value for CexTrait for AnalyzedToken"
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
function cex(at::AnalyzedToken; delimiter = "|", registry = nothing)
    if isempty(at.analyses)
        noanalysis = repeat(delimiter, 7)
        cex(at.ctoken.passage; delimiter = delimiter) * noanalysis * string(typeof(at.ctoken.tokentype))
    else
        lines = []
        for analysis in at.analyses

            push!(lines, join([
                cex(at.ctoken.passage; delimiter = delimiter), 
                cex(analysis; delim = delimiter),
                string(typeof(at.ctoken.tokentype))
                ], delimiter))
        end
        join(lines, "\n")
    end
end

#=
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
=#

"""Parse a one-line delimited-text representation into an `AnalyzedToken`,
using abbreviated URNs for identifiers.  Note that for a sigle CEX line, the `AnalyzedToken` will have a single `Analysis` in its vector of analyses.

$(SIGNATURES)
"""
function fromcex(traitvalue::CexAnalyzedToken, cexsrc::AbstractString, T;      
    delimiter = "|", configuration = nothing, strict = true)

    @debug("Reading CEX to create an AnalyzedToken")


    lines = filter(split(cexsrc, "\n")) do ln
        !isempty(ln)
    end

    @debug("Analyzing delimited for ATken")
    analysislist = Analysis[]
    citabletoken = nothing

    map(lines) do s
        parts = split(s, delimiter)
        
        if length(parts) < 10
            @warn("`fromcex` reading AnalyzedTokenCollection: only got $(length(parts)) columns for data line $(s)")
        else
            cp = CitablePassage(CtsUrn(parts[1]), parts[2])
            @debug("Tring to parse type from $(parts[10])")
            typelabel = parts[10]
            tokentype = typelabel * "()" |> Meta.parse |> eval

            currctoken = CitableToken(cp, tokentype)
            if isnothing(citabletoken)
                citabletoken = currctoken
            else
                if currctoken != citabletoken
                    @warn("Error in CEX source for anlayzed token: different citable tokens in $(currctoken) and $(citabletoken)")
                end
            end


            if isempty(parts[3])
               # skip it. 
            else
                onelinecex = join(parts[3:9], delimiter)
                @debug("Try to make analysis from $(onelinecex)")
                push!(analysislist, fromcex(onelinecex, Analysis; delimiter = delimiter))
            end
            #AnalyzedToken(ctoken, alist) 
        end
    end
    @debug("creating a atoken with $(citabletoken) and analyses $(analysislist)")
    AnalyzedToken(citabletoken, analysislist) 
    
end