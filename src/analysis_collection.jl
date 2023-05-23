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