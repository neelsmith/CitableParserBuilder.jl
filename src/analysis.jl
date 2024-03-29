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

"""Identify token in `a`.
$(SIGNATURES)
"""
function token(a::Analysis)
    a.token
end


"""Identify lexeme in `a`.
$(SIGNATURES)
"""
function lexemeurn(a::Analysis)
    a.lexeme
end

"""Identify morphlogical form in `a`.
$(SIGNATURES)
"""
function formurn(a::Analysis)
    a.form
end

"""Identify lexical stem in `a`.
$(SIGNATURES)
"""
function stemurn(a::Analysis)
    a.stem
end

"""Identify inflectional rule in `a`.
$(SIGNATURES)
"""
function ruleurn(a::Analysis)
    a.rule
end


"""Override `Base.==` for `Analysis`.

$(SIGNATURES)
"""
function ==(a1::Analysis, a2::Analysis)
    a1.token == a2.token && 
    a1.lexeme == a2.lexeme &&
    a1.form == a2.form &&
    a1.stem == a2.stem && 
    a1.rule == a2.rule
end

"""Serialize an `Analysis` to delimited text.
Abbreviated URNs are expanded to full CITE2 URNs
using `registry` as the expansion dictionary.

$(SIGNATURES)
"""
function delimited(a::Analysis; delim = "|", registry = nothing)
    if isnothing(registry)
        join([ a.token,
            a.lexeme,
            a.form,
            a.stem,
            a.rule
            ], delim)

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
function delimited(v::AbstractVector{Analysis}; delim = "|", registry = nothing)
    lines = []
    for analysis in v
        push!(lines, delimited(analysis; delim = delim, registry = registry))
    end

    join(lines, "\n")
end

"""Compose a CEX `relationset` block for a set of analyses.

$(SIGNATURES)
"""
function relationsblock(urn::Cite2Urn, label::AbstractString, v::AbstractVector{Analysis}, delim = "|"; registry = nothing)
    headerlines = [
        "#!citerelationset",
        join(["urn", urn],  delim),
        join(["label", label], delim),
        join(["token", "lexeme", "form", "stem", "rule"], delim)
    ]
    lines = delimited(v; delim = delim, registry = registry)
    join(headerlines, "\n") * lines
end


"""True if any element in stringlist is empty."""
function no_id(stringlist)
    isempty(stringlist[1]) || isempty(stringlist[2]) ||
    isempty(stringlist[3]) || isempty(stringlist[4]) 
end

"""Parse delimited-text representaiton into an `Analysis`.
If delimited-text form uses full Cite2Urns, these are abbreviated.

$(SIGNATURES)
"""
function analysis(s, delim = "|")::Union{Analysis,Nothing}
    parts = split(s, delim)
    tokentext = parts[1]
    
    if no_id(parts[2:5])
        nothing

    else
        lexu = startswith(parts[2], "urn:") ? Cite2Urn(parts[2]) |> abbreviate |> LexemeUrn : LexemeUrn(parts[2])
        formu = startswith(parts[3], "urn:") ? Cite2Urn(parts[3]) |> abbreviate |> FormUrn : FormUrn(parts[3])
        stemu = startswith(parts[4], "urn:") ? Cite2Urn(parts[4]) |> abbreviate |> StemUrn : StemUrn(parts[4])
        ruleu = startswith(parts[5], "urn:") ? Cite2Urn(parts[5]) |> abbreviate |> RuleUrn : RuleUrn(parts[5])

        Analysis(
            tokentext,
            lexu,
            formu,
            stemu,
            ruleu
        )
    end
end



"""Compose a string listing tokens from a list of `Analysis` objects
"""
function tokentext(v::Vector{Analysis})::AbstractString
    strvals = map(a -> a.token, v)
    join(strvals, ", ")
end






#=
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
=#