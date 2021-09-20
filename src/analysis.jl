"""Citable analysis of a string value.

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

"""Serialize an `Analysis` to delimited text.
Abbreviated URNs are expanded to full CITE2 URNs
using `registry` as the expansion dictionary.

$(SIGNATURES)
"""
function cex(a::Analysis, delim = "|", registry = nothing)
    if isnothing(registry)
        abbrcex(a, delim)
    else
        join([ a.token,
            expand(a.lexeme, registry),
            expand(a.form, registry),
            expand(a.rule, registry),
            expand(a.stem, registry)
            ], delim)
    end
end

"""Serialize an `Analysis` using abbreviated URNs as identifiers.

$(SIGNATURES)
"""
function abbrcex(a::Analysis, delim = "|")
    @info("Seralizing analysis with abbreviations")
    join([ a.token,
        abbreviation(a.lexeme),
        abbreviation(a.form),
        abbreviation(a.rule),
        abbreviation(a.stem)
        ], delim)
end


"""Compose delimited text representation for a 
map of tokens to a vector of analyses.

$(SIGNATURES)

This could be useful for serializing analyzes for a list
of unique tokens in a corpus.    
"""
function cex(prs)::Tuple{ String, Vector{Analysis} }
    cexlines = []
    for pr in prs
        if isempty(pr[2])
            push!(cexlines, string(pr[1],"|"))
        else
            for id in pr[2]
                push!(cexlines, string(pr[1],"|", cex(id)))
            end
        end
    end
    join(cexlines,"\n")
end


"""Parse delimited-text representaiton into an `Analysis`.

$(SIGNATURES)
"""
function analysis_fromcex(s, delim = ",")::Analysis
    parts = split(s, delim)
    Analysis(parts[1],
    LexemeUrn(parts[2]),
    FormUrn(parts[3]),
    StemUrn(parts[4]),
    RuleUrn(parts[5])
    )
end


"""Parse delimited-text representaiton into an `AnalyzedToken`.

$(SIGNATURES)
"""
function analyzedtoken_fromcex(s, delim = ",")::AnalyzedToken
    parts = split(s, delim)
    cn = CitablePassage(CtsUrn(parts[1]), parts[2])
    Analysis(cn,
    parts[3],
    LexemeUrn(parts[4]),
    FormUrn(parts[5]),
    StemUrn(parts[6]),
    RuleUrn(parts[7])
    )
end

