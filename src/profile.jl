struct TextCounts
    corpus_size::Int
    vocabulary_size::Int
    parsed_tokens::Int
    parsed_vocabulary::Int
    lexicon_size::Int
    forms::Int
    ambiguous_tokens::Int
    morphologically_ambiguous::Int
    lexically_ambiguous::Int
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



"""Profile a citable corpus.

$(SIGNATURES)
"""
function profile(c::CitableTextCorpus, p::CitableParser;  data = nothing)
    analyses = parsecorpus(c, p; data = data)
    count_analyses(analyses)
end


"""Profile a citable doocument.

$(SIGNATURES)
"""
function profile(d::CitableDocument, p::CitableParser;  data = nothing)
    analyses = parsedocument(d, p; data = data)
    count_analyses(analyses)
end

"""Profile a citable passage.

$(SIGNATURES)
"""
function profile(psg::CitablePassage, p::CitableParser;  data = nothing)
    analyses = parsepassage(psg, p; data = data)
    count_analyses(analyses)
end