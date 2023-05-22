
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
        noanalysis = "|||||"
        cex(at.passage; delimiter = delimiter) * noanalysis
    else
        lines = []
        for analysis in at.analyses

            push!(lines, join([
                cex(at.ctoken.passage; delimiter = delimiter), 
                delimited(analysis, delimiter),
                typeof(at.ctoken.tokentype)
                ], delimiter))
        end
        join(lines, "\n")
    end
end


"""Serialize a single `AnalyzedToken` as one or more lines of delimited text.

$(SIGNATURES)
"""
function delimited(at::AnalyzedToken, delim = "|"; registry = nothing)
    if isnothing(registry)
        @warn("No registry defined:  serializing AnalyzedToken with abbreviated URN values.")
    end
    if isempty(at.analyses)
        noanalysis = "|||||"
        cex(at.passage; delimiter = delim) * noanalysis
    else
        lines = []
        for analysis in at.analyses
            push!(lines, 
            join([
                cex(at.ctoken.passage; delimiter = delim), 
                delimited(analysis, delim; registry = registry),
                at.ctoken.tokentype
                ], delim))
        end
        join(lines, "\n")
    end
end

"""Serialize a Vector of `AnalyzedToken`s as delimited text.

$(SIGNATURES)
"""
function delimited(v::AbstractVector{AnalyzedToken}, delim = "|"; registry = nothing)
    lines = []
    for at in v
        push!(lines, delimited(at, delim; registry = registry))
    end
    #flattened = lines |> Iterators.flatten |> collect
    join(lines, "\n")
end
