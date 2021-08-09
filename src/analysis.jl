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


"""Compose delimited text representation for a 
map of tokens to a vector of analyses.

$(SIGNATURES)
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
function fromcex(s, delim = ",")::Analysis
    parts = split(s, delim)
    Analysis(parts[1],
    LexemeUrn(parts[2]),
    FormUrn(parts[3]),
    StemUrn(parts[4]),
    RuleUrn(parts[5])
    )
end
