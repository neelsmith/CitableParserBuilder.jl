"""Direct observations on a Vector of `AnalyzedToken`s.

This is really an intermediate convenience type for building a fuller
`TextProfile`.
"""
struct TextCounts
    corpus_size::Int
    vocabulary_size::Int
    parsed_tokens::Int
    parsed_vocabulary::Int
    lexicon_size::Int
    forms::Int
    ambiguous_tokens::Int
    m_ambiguous::Int
    l_ambiguous::Int
end

"""Summarize a Vector of `AnalyzedToken`s with basic observations summarized as a `TextCounts` object.

$(SIGNATURES)
"""
function count_analyses(v)
    tokencount = length(v)
    vocabsize = map(tkn -> tkn.passage.text, v) |> unique |> length

    has_analysis = filter(tkn -> ! isempty(tkn.analyses), v)
    parsed = length(has_analysis)
    parsed_vocab = map(tkn -> tkn.passage.text, has_analysis) |> unique |> length

    analyses =  map(tkn -> tkn.analyses, v) |> Iterators.flatten |> collect
    lexemes = map(a -> a.lexeme, analyses) |> unique |> length
    forms = map(a -> a.form, analyses) |> unique |> length
    
    ambiguous = filter(t -> length(t.analyses) > 1, v) |> length

    morphlists = []
    for at in v
        morphlist = map(a -> a.form, at.analyses) |> unique
        push!(morphlists, morphlist)
    end
    morph_ambig = filter(l -> length(l) > 1, morphlists) |> length


    lexlists = []
    for at in v
        lexlist = map(a -> a.lexeme, at.analyses) |> unique
        push!(lexlists, lexlist)
    end
    lex_ambig = filter(l -> length(l) > 1, lexlists) |> length

    
    TextCounts(
        tokencount,
        vocabsize,
        parsed,
        parsed_vocab,
        lexemes,
        forms,
        ambiguous,
        morph_ambig,
        lex_ambig
    )
end


"""Format a verbose display of `TextCounts`.

$(SIGNATURES)
"""
function pretty_print(tc::TextCounts)
"""
tokens: $(tc.corpus_size)
tokens parsed: $(tc.parsed_tokens)
vocabulary items: $(tc.vocabulary_size)
vocabulary parsed: $(tc.parsed_vocabulary)
lexicon: $(tc.lexicon_size)
forms: $(tc.forms)
ambiguous tokens: $(tc.ambiguous_tokens)
morphologically ambiguous: $(tc.morphologically_ambiguous)
lexically ambiguous: $(tc.lexically_ambiguous)
"""
end


