"""Extract a list of string token values from a Vector of `Analysis` objects.
$(SIGNATURES)
"""
function tokens(v::AbstractVector{Analysis})
    map(a -> string(a.token), v) |> unique
end

"""Extract a list of string token values from a Vector of `AnalyzedToken` objects.
$(SIGNATURES)
"""
function tokens(v::AbstractVector{AnalyzedToken})
    analyses = map(p -> p.analyses, v) |> Iterators.flatten |> collect
    tokens(analyses)
end

"""Extract a list of string token values from an `AnalyzedTokens` object.
$(SIGNATURES)
"""
function tokens(atokens::AnalyzedTokens)
    tokens(atokens.analyses)
end




"""Extract a list of lexemes from a Vector of `Analysis` objects.
$(SIGNATURES)
"""
function lexemes(v::AbstractVector{Analysis})
    map(a -> a.lexeme, v) .|> string |> unique .|> LexemeUrn
end

"""Extract a list of lexemes from a Vector of `AnalyzedToken` objects.
$(SIGNATURES)
"""
function lexemes(v::AbstractVector{AnalyzedToken})
    analyses = map(p -> p.analyses, v) |> Iterators.flatten |> collect
    lexemes(analyses)
end

"""Extract a list of lexemes from an `AnalyzedTokens` object.
$(SIGNATURES)
"""
function lexemes(atokens::AnalyzedTokens)
    lexemes(atokens.analyses)
end











#=
"""Extract a list of lexeme values from a Vector of `AnalyzedToken`s.
$(SIGNATURES)
"""
function lexemes(v::AbstractVector{Analysis})
    analyses = map(p -> p.analyses, v) |> Iterators.flatten |> collect
    map(a -> string(a.token), analyses) |> unique
end

=#


