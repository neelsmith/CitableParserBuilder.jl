"""A collection of analyzed tokens."""
struct AnalyzedTokens
    analyses::Vector{AnalyzedToken}
end

"""Override Base.show for `AnalyzedTokens`.
$(SIGNATURES)
"""
function show(io::IO, analyses::AnalyzedTokens)
    length(analyses.analyses) == 1 ? print(io, "Collection of  1 analysis") : print(io, "Collection of ", length(analyses.analyses), " analyzed tokens.")
end

"Value for CitableTrait."
struct CitableAnalyses <: CitableCollectionTrait end

"""Define`CitableTrait` value for `AnalyzedTokens`.
$(SIGNATURES)
"""
function citablecollectiontrait(::Type{AnalyzedTokens})
    CitableAnalyses()
end

"""Typeof URN identifying analyses in an an `AnalyzedTokens` collection.
$(SIGNATURES)
Required function for `Citable` abstraction.
"""
function urntype(analyses::AnalyzedTokens)
    CtsUrn
end


"""Label for `analyses`.
$(SIGNATURES)
Required function for `Citable` abstraction.
"""
function label(analyses::AnalyzedTokens)
    string(analyses)
end


"Value for CexTrait"
struct AnalysesCex <: CexTrait end

"""Define`CexTrait` value for `AnalyzedTokens`.
$(SIGNATURES)
"""
function cextrait(::Type{AnalyzedTokens})
    AnalysesCex()
end


"""Format an `AnalyzedTokens` collection as a delimited-text string.
$(SIGNATURES)
Required function for `Citable` abstraction.
"""
function cex(analyses::AnalyzedTokens; delimiter = "|")
    header = "#!ctsdata\n"

    strings = map(atoken -> cex(atoken, delimiter=delimiter), analyses)
    header * join(strings, "\n")
end


"""Parse a delimited-text string into an `AnalyzedTokens` collection.
$(SIGNATURES)
"""
function fromcex(trait::AnalysesCex, s::AbstractString,  ::Type{AnalyzedTokens}; delimiter = "|", configuration = nothing, strict = true)
    rawlines = split(s, "\n")[2:end]
    datalines = filter(ln -> ! isempty(ln), rawlines)
    prevcitable = nothing
    curranalyses = []
    tokens = AnalyzedToken[]
    
    for ln in datalines
        parts = split(ln, delimiter)
        @debug("LINEL: ", ln)
        currpsg = CitablePassage(CtsUrn(parts[1]), parts[2])
        ttype = parts[8] * "()" |> Meta.parse |> eval
        currcitable = CitableToken(currpsg, ttype)
        @debug("CURRCITALBBE", currcitable)
        analysisstring = join([parts[3], parts[4], parts[5], parts[6], parts[7]], delimiter)
        currentanalysis = analysis(analysisstring, delimiter)

        if isnothing(prevcitable)
            prevcitable = currcitable
            @debug("SET PREV", prevcitable)
            curranalyses = [currentanalysis]

        elseif urn(currcitable) != urn(prevcitable)
            push!(tokens, AnalyzedToken(prevcitable, curranalyses))
            prevcitable = currcitable
            @debug("SET PREV", prevcitable)
            curranalyses = [currentanalysis]
            
        else
            push!(curranalyses, currentanalysis)
        end
        
    end
    @debug("PREVCITABLE: " , prevcitable)
    push!(tokens, AnalyzedToken(prevcitable, curranalyses))
    
    AnalyzedTokens(tokens)
end

"""Implement iteration for `AnalyzedTokens`.
$(SIGNATURES)
"""
function iterate(analyses::AnalyzedTokens)
    isempty(analyses.analyses) ? nothing : (analyses.analyses[1], 2)
end


"""Implement iteration with state for `AnalyzedTokens`.
$(SIGNATURES)
"""
function iterate(analyses::AnalyzedTokens, state)
    state > length(analyses.analyses) ? nothing : (analyses.analyses[state], state + 1)
end

"""Implement base element type for `AnalyzedTokens`.
$(SIGNATURES)
"""
function eltype(analyses::AnalyzedTokens)
    AnalyzedToken
end

function length(analyses::AnalyzedTokens)
    length(analyses.analyses)
end