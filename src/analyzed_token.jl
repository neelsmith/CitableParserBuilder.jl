"""Morphological analyses for a token identified by CTS URN.
"""
struct AnalyzedToken <: Citable
    ctoken::CitableToken
    analyses::Vector{Analysis}
end

"""Override Base.show for `AnalyzedToken`.
$(SIGNATURES)
"""
function show(io::IO, atoken::AnalyzedToken)
    print(io, atoken.ctoken, ": ", length(atoken.analyses), " analyses")
end


"""Override `Base.==` for `AnalyzedToken`.
$(SIGNATURES)
"""
function ==(atoken1::AnalyzedToken, atoken2::AnalyzedToken)
    atoken1.ctoken == atoken2.ctoken && 
    atoken1.analyses == atoken2.analyses
end



"Value for CitableTrait."
struct CitableByAnalysis <: CitableTrait end

"""Define`CitableTrait` value for `CitableToken`.
$(SIGNATURES)
"""
function citabletrait(::Type{AnalyzedToken})
    CitableByAnalysis()
end

"""Unique identifier for `AnalyzedToken` (required for `Citable` interface).
$(SIGNATURES)
"""
function urn(at::AnalyzedToken)
    urn(at.ctoken)
end


"""Identify URN type for an `AnalyzedToken` as `CtsUrn`.
$(SIGNATURES)
Required function for `Citable` abstraction.
"""
function urntype(at::AnalyzedToken)
    CtsUrn
end

"""Label for `AnalyzedToken` (required for `Citable` interface).
$(SIGNATURES)
"""
function label(at::AnalyzedToken)
    length(at.analyses) == 1 ? string("$(at.ctoken): 1 analysis.") :
    string("$(at.ctoken): $(length(at.analyses)) analyses.")
end






#=




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
            @debug("Adding to current passages ", currentPassage )
            push!(currentAnalyses, tkn.analyses[1])
        else
            if ! isnothing(currentPassage)
                push!(analyses, AnalyzedToken(currentPassage, currentAnalyses))
                @debug("Add analysis to empty passage; results now ", length(analyses), currentPassage)
            end

            currentPassage = tkn.passage
            currentAnalyses = tkn.analyses
            @debug("Set curr. analyses to ", currentAnalyses, currentPassage)
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
            @debug("Adding to current passages ", currentPassage )
            push!(currentAnalyses, tkn.analyses[1])
        else
            if ! isnothing(currentPassage)
                push!(analyses, AnalyzedToken(currentPassage, currentAnalyses))
                @debug("Add analysis to empty passage; results now ", length(analyses), currentPassage)
            end

            currentPassage = tkn.passage
            currentAnalyses = tkn.analyses
            @debug("Set curr. analyses to ", currentAnalyses, currentPassage)
        end
    end  
    push!(analyses, AnalyzedToken(currentPassage, currentAnalyses))

    analyses
end
=#

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
    urnstrings = map(pr -> pr[1].urn.urn, matches) |> unique
    map(u -> CtsUrn(u), urnstrings)
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