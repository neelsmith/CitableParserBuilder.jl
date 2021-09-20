"""Morphological analyses for a token identified by CTS URN.
"""
struct AnalyzedToken <: Citable
    passage::CitablePassage
    analyses::Vector{Analysis}
end

"""Label for `AnalyzedToken` (required for `Citable` interface).
$(SIGNATURES)
"""
function label(at::AnalyzedToken)
    string("Analysis of ", at.passage)
end

"""Unique identifier for `AnalyzedToken` (required for `Citable` interface).
$(SIGNATURES)
"""
function urn(at::AnalyzedToken)
    at.passage.urn
end


"""Serialize an `AnalyzedToken` as delimited text (required for `Citable` interface).

$(SIGNATURES)
"""
function abbrcex(at::AnalyzedToken, delim = "|")
    lines = []
    for analysis in at.analyses
        @info("SERALIZING ONE ANALYSIS ", analysis)
        push!(lines, cex(analysis, delim))
       # push!(lines, 
            #join(cex(at.passage, delim), cex(analysis, delim), delim)
        #)
    end
    lines
end

function cex(at::AnalyzedToken, delim = "|"; registry = nothing)
    if isnothing(registry)
        abbrcex(at, delim)
    else
        lines = []
        for analysis in at.analyses
            push!(lines, cex(at.passage, delim), cex(analysis, delim, registry = registry))
        end
        lines
    end
end