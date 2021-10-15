"""Serialize an `AnalyzedToken` as delimited text (required for `Citable` interface).

$(SIGNATURES)
Uses abbreviated URNs.  
These can be expanded to full CITE2 URNs when read back with a URN registry,
or the `delimited` function can be used with a URN registry to write full CITE2 URNs.
"""
function cex(at::AnalyzedToken, delim = "|")
    if isempty(at.analyses)
        noanalysis = "|||||"
        cex(at.passage, delim) * noanalysis
    else
        lines = []
        for analysis in at.analyses
            push!(lines, join([
                cex(at.passage, delim), 
                delimited(analysis, delim)
                ], delim))
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
        cex(at.passage, delim) * noanalysis
    else
        lines = []
        for analysis in at.analyses
            push!(lines, 
            join([
                cex(at.passage, delim), 
                delimited(analysis, delim; registry = registry)
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
