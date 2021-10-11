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
function cex(a::Analysis, delim = "|"; registry = nothing)
    if isnothing(registry)
        abbrcex(a, delim)
    else
        join([ a.token,
            expand(a.lexeme, registry),
            expand(a.form, registry),
            expand(a.stem, registry),
            expand(a.rule, registry)
            ], delim)
    end
end



"""Serialize a Vector of `Analysis` objects as delimited text.

$(SIGNATURES)
"""
function cex(v::AbstractVector{Analysis}, delim = "|"; registry = nothing)
    lines = []
    for analysis in v
        push!(lines, cex(analysis, delim; registry = registry))
    end

    join(lines, "\n")
end

"""Compose a CEX `relationset` block for a set of analyses.

$(SIGNATURES)
"""
function analyses_relationsblock(urn::Cite2Urn, label::AbstractString, v::AbstractVector{Analysis}, delim = "|"; registry = nothing)
    headerlines = [
        "#!citerelationset",
        join(["urn", urn],  delim),
        join(["label", label], delim),
        join(["token", "lexeme", "form", "stem", "rule"], delim)
    ]
    cexlines = cex(v, delim, registry = registry)
    join(headerlines, "\n") * cexlines
end

"""Serialize an `Analysis` using abbreviated URNs as identifiers.

$(SIGNATURES)
"""
function abbrcex(a::Analysis, delim = "|")
    join([ a.token,
        a.lexeme,
        a.form,
        a.stem,
        a.rule
        ], delim)
end


"""Compose delimited text representation for a 
map of tokens to a vector of analyses.

$(SIGNATURES)

This could be useful for serializing analyzes for a list
of unique tokens in a corpus.    
"""
function tokenmap_cex(prs)::Tuple{ String, Vector{Analysis} }
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
    Analysis(
        parts[1],
        Cite2Urn(parts[2]) |> abbreviate |> LexemeUrn,
        Cite2Urn(parts[3]) |> abbreviate |> FormUrn,
        Cite2Urn(parts[4]) |> abbreviate |> StemUrn,
        Cite2Urn(parts[5]) |> abbreviate |> RuleUrn
    )
end

