"""A citable morphological analysis.

An `Analysis` has five members: a token string value, and four abbreviated
URNs, one each for the lexeme, form, rule and stem.
"""
struct Analysis
    token::AbstractString
    lexeme::LexemeUrn
    form::FormUrn
    stem::StemUrn
    rule::RuleUrn
end

"""Serialize an `Analaysis` as delimted text.

$(SIGNATURES)
"""
function cex(a::Analysis, delim = ",")
    join([ a.token,
        abbreviation(a.lexeme),
        abbreviation(a.form),
        abbreviation(a.rule),
        abbreviation(a.stem)
        ], delim)
end

"""Morphological analyses for a token identified by CTS URN.
"""
struct AnalyzedToken
    surfacetoken::AbstractString
    texturn::CtsUrn
    analyses::Vector{Analysis}
end

"""Serialize an `Analaysis` as delimited text.

$(SIGNATURES)
"""
function cex(tkn::AnalyzedToken; delim="|", delim2=";", delim3=",")
    alist = []
    for a in tkn.analyses
        push!(alist, cex(a,delim3))
    end
    columns = [tkn.surfacetoken, tkn.texturn.urn, join(alist,delim2)]
    join(columns, delim)
end
