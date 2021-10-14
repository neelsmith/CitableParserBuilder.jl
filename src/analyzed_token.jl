"""Morphological analyses for a token identified by CTS URN.
"""
struct AnalyzedToken <: Citable
    passage::CitablePassage
    analyses::Vector{Analysis}
end

"""Assign value for `CitableTrait`.
NB: required cex() function is implemented in file serialization.jl.
"""
CitableTrait(::Type{AnalyzedToken}) = CitableByCtsUrn()

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


## Functions to instantiate AnalyzedTokens from delimited text source.

"""Parse a one-line delimited-text representation intno an `AnalyzedToken`, using abbreviated URNs for identifiers.  Note that for a sigle CEX line, the `AnalyzedToken` will have a single `Analysis` in its vector of analyses.

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


"""Parse a string of delimited-text into a Vector of `AnalyzedToken`s. 

$(SIGNATURES)
"""
function analyzedtokens_fromabbrcex(cexsrc, delim = "|")
    cexlines = split(cexsrc, "\n")
    analyses = AnalyzedToken[] 
    currentPassage = nothing
    currentAnalyses = AnalyzedToken[]
    for ln in filter(l -> ! isempty(l), cexlines)
        tkn = analyzedtoken_fromabbrcex(ln, delim)
        if tkn.passage == currentPassage
            #@info("Adding to current passages ", currentPassage )
            push!(currentAnalyses, tkn.analyses[1])
        else
            if ! isnothing(currentPassage)
                push!(analyses, AnalyzedToken(currentPassage, currentAnalyses))
                #@info("Add analysis to empty passage; results now ", length(analyses), currentPassage)
            end

            currentPassage = tkn.passage
            currentAnalyses = tkn.analyses
            #@info("Set curr. analyses to ", currentAnalyses, currentPassage)
        end
    end  
    push!(analyses, AnalyzedToken(currentPassage, currentAnalyses))

    analyses
end


"""Parse a string of delimited-text into a Vector of `AnalyzedToken`s. 

$(SIGNATURES)
"""
function analyzedtokens_fromcex(cexsrc, delim = "|")
    cexlines = split(cexsrc,"\n")
    analyses = [] 
    currentPassage = nothing
    currentAnalyses = AnalyzedToken[]
    for ln in filter(l -> ! isempty(l), cexlines)
        tkn = analyzedtoken_fromcex(ln, delim)
        if tkn.passage == currentPassage
            #@info("Adding to current passages ", currentPassage )
            push!(currentAnalyses, tkn.analyses[1])
        else
            if ! isnothing(currentPassage)
                push!(analyses, AnalyzedToken(currentPassage, currentAnalyses))
                #@info("Add analysis to empty passage; results now ", length(analyses), currentPassage)
            end

            currentPassage = tkn.passage
            currentAnalyses = tkn.analyses
            #@info("Set curr. analyses to ", currentAnalyses, currentPassage)
        end
    end  
    push!(analyses, AnalyzedToken(currentPassage, currentAnalyses))

    analyses
end
