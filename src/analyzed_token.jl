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

"""Serialize an `AnalyzedToken` as delimited text with abbreviated URN values.

$(SIGNATURES)
"""
function abbrcex(at::AnalyzedToken, delim = "|")
    lines = []
    for analysis in at.analyses
        str = join([
            cex(at.passage, delim), 
            cex(analysis, delim)
            ], delim)
        push!(lines, str)
    end
    lines
end

"""Serialize an `AnalyzedToken` as delimited text (required for `Citable` interface).

$(SIGNATURES)
"""
function cex(at::AnalyzedToken, delim = "|"; registry = nothing)
    if isnothing(registry)
        @warn("No registry defined:  serializing with abbreviated URN values.")
        abbrcex(at, delim)
    else
        lines = []
        for analysis in at.analyses
            push!(lines, cex(at.passage, delim), cex(analysis, delim; registry = registry))
        end
        lines
    end
end


"""Parse a one-line delimited-text representation into an `AnalyzedToken`, using abbreviated URNs for identifiers.  Note that for a single CEX line, the `AnalyzedToken` will have a single `Analysis` in its vector of analyses.

$(SIGNATURES)
"""
function analyzedtoken_fromabbrcex(s, delim = "|")::AnalyzedToken
    parts = split(s, delim)
    cn = CitablePassage(CtsUrn(parts[1]), parts[2])
    AnalyzedToken(
        cn,
        [Analysis( 
            parts[3],
            LexemeUrn(parts[4]),
            FormUrn(parts[5]),
            StemUrn(parts[6]),
            RuleUrn(parts[7]))
        ]
    )
end

"""Parse a one-line delimited-text representation into an `AnalyzedToken`, using CITE2 URNs for identifiers.  Note that for a single CEX line, the `AnalyzedToken` will have a single `Analysis` in its vector of analyses.

$(SIGNATURES)
"""
function analyzedtoken_fromcex(s, delim = "|")
    parts = split(s, delim)
    cn = CitablePassage(CtsUrn(parts[1]), parts[2])
    AnalyzedToken(
        cn,
        [Analysis( 
            parts[3],
            Cite2Urn(parts[4]) |> abbreviate |> LexemeUrn,
            Cite2Urn(parts[5]) |> abbreviate |> FormUrn,
            Cite2Urn(parts[6]) |> abbreviate |> StemUrn,
            Cite2Urn(parts[7]) |> abbreviate |>  RuleUrn   
        )]
    )
end



"""Parse a Vector of lines of delimited-text into a Vector of `AnalyzedToken`s. 

$(SIGNATURES)
"""
function analyzedtokens_fromabbrcex(cexlines, delim = "|")
    analyses = [] 
    currentPassage = nothing
    currentAnalyses = []
    for ln in filter(l -> ! isempty(l), cexlines)
        tkn = analyzedtoken_fromabbrcex(ln, delim)
        if tkn.passage == currentPassage
            @info("Adding to current passages ", currentPassage )
            push!(currentAnalyses, tkn.analyses[1])
        else
            if ! isnothing(currentPassage)
                push!(analyses, AnalyzedToken(currentPassage, currentAnalyses))
                @info("Add analysis to empty passage; results now ", length(analyses), currentPassage)
            end

            currentPassage = tkn.passage
            currentAnalyses = tkn.analyses
            @info("Set curr. analyses to ", currentAnalyses, currentPassage)
        end
    end  
    push!(analyses, AnalyzedToken(currentPassage, currentAnalyses))

    analyses
end



function analyzedtokens_fromcex()
    @warn("Not yet implemented")
end
