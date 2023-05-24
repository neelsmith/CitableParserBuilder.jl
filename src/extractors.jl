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


"""Extract a list of rules from a Vector of `Analysis` objects.
$(SIGNATURES)
"""
function rules(v::AbstractVector{Analysis})
    map(a -> a.rule, v) .|> string |> unique .|> RuleUrn
end

"""Extract a list of rules from a Vector of `AnalyzedToken` objects.
$(SIGNATURES)
"""
function rules(v::AbstractVector{AnalyzedToken})
    analyses = map(p -> p.analyses, v) |> Iterators.flatten |> collect
    rules(analyses)
end

"""Extract a list of rules from an `AnalyzedTokens` object.
$(SIGNATURES)
"""
function rules(atokens::AnalyzedTokens)
    rules(atokens.analyses)
end



"""Extract a list of stems from a Vector of `Analysis` objects.
$(SIGNATURES)
"""
function stems(v::AbstractVector{Analysis})
    map(a -> a.stem, v) .|> string |> unique .|> StemUrn
end

"""Extract a list of stems from a Vector of `AnalyzedToken` objects.
$(SIGNATURES)
"""
function stems(v::AbstractVector{AnalyzedToken})
    analyses = map(p -> p.analyses, v) |> Iterators.flatten |> collect
    stems(analyses)
end

"""Extract a list of stems from an `AnalyzedTokens` object.
$(SIGNATURES)
"""
function stems(atokens::AnalyzedTokens)
    stems(atokens.analyses)
end



"""Extract a list of forms from a Vector of `Analysis` objects.
$(SIGNATURES)
"""
function forms(v::AbstractVector{Analysis})
    map(a -> a.form, v) .|> string |> unique .|> FormUrn
end

"""Extract a list of forms from a Vector of `AnalyzedToken` objects.
$(SIGNATURES)
"""
function forms(v::AbstractVector{AnalyzedToken})
    analyses = map(p -> p.analyses, v) |> Iterators.flatten |> collect
    forms(analyses)
end

"""Extract a list of forms from an `AnalyzedTokens` object.
$(SIGNATURES)
"""
function forms(atokens::AnalyzedTokens)
    forms(atokens.analyses)
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


