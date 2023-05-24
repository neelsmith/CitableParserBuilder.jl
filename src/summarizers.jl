

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