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





"""Parse a one-line delimited-text representation into an `AnalyzedToken`,
using abbreviated URNs for identifiers.  Note that for a sigle CEX line, the `AnalyzedToken` will have a single `Analysis` in its vector of analyses.

$(SIGNATURES)
"""
function analyzedtoken_fromabbrcex(s, delim = "|")::AnalyzedToken
    parts = split(s, delim)
    psg = CitablePassage(CtsUrn(parts[1]), parts[2])
    isempty(parts[3]) ? AnalyzedToken(psg, Analysis[]) : AnalyzedToken(
        psg,
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
    psg = CitablePassage(CtsUrn(parts[1]), parts[2])
    isempty(parts[3]) ? AnalyzedToken(psg, Analysis[]) :
    AnalyzedToken(
        psg,
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
    analyses = AnalyzedToken[] 
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


"""Extract a list of lexeme values from a Vector of `AnalyzedToken`s.

$(SIGNATURES)
"""
function lexemes(v::AbstractVector{AnalyzedToken})
    analyses = map(p -> p.analyses, v) |> Iterators.flatten |> collect
    map(a -> string(a.lexeme), analyses) |> unique
end


"""Flatten a Vector of `AnalyzedToken`s into passage+anlaysis pairs.

$(SIGNATURES)
"""
function flatpairs(v::AbstractVector{AnalyzedToken})
    pairlist = []
    for ta in v
        for a in ta.analyses
            push!(pairlist, (ta.passage, a))
        end
    end
    pairlist
end


"""Find token string values for all tokens in a vector of `AnalyzedToken`s parsed to a given lexeme.

$(SIGNATURES)
"""
function stringsforlexeme(v::AbstractVector{AnalyzedToken}, l::AbstractString)
    paired = flatpairs(v)
    matches = filter(pr -> string(pr[2].lexeme) == l, paired)
    map(pr -> pr[1].text, matches) |> unique
end

"""Find URNs for all tokens in a vector of `AnalyzedToken`s parsed to a given lexeme.

$(SIGNATURES)
"""
function passagesforlexeme(v::AbstractVector{AnalyzedToken}, l::AbstractString)
    paired = flatpairs(v)
    matches = filter(pr -> string(pr[2].lexeme) == l, paired)
    map(pr -> pr[1].urn, matches) |> unique
end

"""From a vector `AnalyzedToken`s and an index of tokens in a corpus,
construct a dictionary keyed by lexemes, mapping to a further dictionary
of surface forms to passages.

$(SIGNATURES)
"""
function lexemedictionary(parses, tokenindex)
    lexformdict = Dict()
    for l in lexemes(parses)
        singlelexdict = Dict()   
        formlist = stringsforlexeme(parses, l)
        for f in formlist
            singlelexdict[f] = tokenindex[f]
        end
        lexformdict[l] = singlelexdict
    end
    lexformdict
end