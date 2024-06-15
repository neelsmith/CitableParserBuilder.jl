

"""Flatten a Vector of `AnalyzedToken`s into passage+anlaysis pairs.

$(SIGNATURES)
"""
function flatpairs(v::AbstractVector{AnalyzedToken})
    pairlist = []
    for ta in v
        for a in ta.analyses
            push!(pairlist, (ta.ctoken.passage, a))
        end
    end
    pairlist
end

function stringsforlexeme(atcollection::AnalyzedTokenCollection, lexstr::AbstractString)
    stringsforlexeme(atcollection.analyses, lexstr)
end

"""Find token string values for all tokens in a vector of `AnalyzedToken`s parsed to a given lexeme.

$(SIGNATURES)
"""
function stringsforlexeme(v::AbstractVector{AnalyzedToken}, lexstr::AbstractString)::Vector{AbstractString}
    paired = flatpairs(v)
    matches = filter(pr -> string(pr[2].lexeme) == lexstr, paired)
    map(pr -> pr[1].text, matches) |> unique
end

"""Find URNs for all tokens in a vector of `AnalyzedToken`s parsed to a given lexeme.

$(SIGNATURES)
"""
function passagesforlexeme(v::AbstractVector{AnalyzedToken}, lexstr::AbstractString)::Vector{CtsUrn}
    paired = flatpairs(v)
    matches = filter(pr -> string(pr[2].lexeme) == lexstr, paired)
    urnstrings = map(pr -> pr[1].urn.urn, matches) |> unique 
    map(u -> CtsUrn(u), urnstrings)
end


function lexemedictionary(parses::AnalyzedTokenCollection, tokenindex::Dictionary{String, Vector{CtsUrn}})
    lexemedictionary(parses.analyses, tokenindex)
end

"""From a vector of `AnalyzedToken`s and an index of tokens in a corpus,
construct a dictionary keyed by lexemes, mapping to a further dictionary
of surface forms to passages.

$(SIGNATURES)
"""
function lexemedictionary(parses::Vector{AnalyzedToken}, tokenindex::Dictionary{String, Vector{CtsUrn}}
 
    )
    lexformdict = Dict()
    for l in lexemes(parses)
        lexstr = string(l)
        singlelexdict = Dict()   
        formlist = stringsforlexeme(parses, lexstr)
        for f in formlist
            if haskey(tokenindex, f)
                singlelexdict[f] = tokenindex[f]
            else
                @warn("Token $(l) not found in token index.")
            end
        end
        lexformdict[lexstr] = singlelexdict
    end
    lexformdict
end


"""Compute histogram of lexemes in `AnalyzedTokenCollection`.
$(SIGNATURES)
All distinct lexemes for a token are counted; there is no weighting of counts for 
lexically ambiguous tokens.
"""
function lexemehisto(parses::AnalyzedTokenCollection)
    counts = map(a -> lexemes(a.analyses), parses.analyses) |> Iterators.flatten |> collect .|> string |> countmap
    sort!(OrderedDict(counts); byvalue=true, rev=true)
end