"""Morphological analyses for a token identified by CTS URN.
"""
struct AnalyzedToken <: Citable
    ctoken::CitableToken
    analyses::Vector{Analysis}
end

function analyses(at::AnalyzedToken)
    at.analyses
end

function passage(at::AnalyzedToken)
    at.ctoken |> passage
end


"""Get URN for analysis.
$(SIGNATURES)
"""
function text(at::AnalyzedToken)
    at.ctoken |> passage |> text
end


"""Get citable token for analysis.
$(SIGNATURES)
"""
function ctoken(at::AnalyzedToken)
    at.ctoken
end


"""Override Base.show for `AnalyzedToken`.
$(SIGNATURES)
"""
function show(io::IO, atoken::AnalyzedToken)
    length(atoken.analyses) == 1 ? print(io, atoken.ctoken, ": 1 analysis" ) : print(io, atoken.ctoken, ": ", length(atoken.analyses), " analyses")
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
