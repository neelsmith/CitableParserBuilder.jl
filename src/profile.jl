

# Computations on TextCounts

"""Compute ratio of distinct forms to all tokens parsed.

$(SIGNATURES)
"""
function formal_ambiguity(tc::TextCounts)
    tc.morphologically_ambiguous / tc.parsed_tokens
end


"""Compute ratio of lexically ambiguous tokens  to all parsed tokens.

$(SIGNATURES)
"""
function lexical_ambiguity(tc::TextCounts)
    tc.lexically_ambiguous / tc.parsed_tokens
end


"""Compute ratio of lexicon to distinct forms.

$(SIGNATURES)
"""
function form_density_inlexicon(tc::TextCounts)
    tc.lexicon_size / tc.forms
end

"""Compute ratio of tokens to distinct forms.

$(SIGNATURES)
"""
function form_density_incorpus(tc::TextCounts)
    tc.corpus_size / tc.forms
end


"""Compute ratio of vocabulary items to distinct forms.

$(SIGNATURES)
"""
function form_density_invocabulary(tc::TextCounts)
    tc.vocabulary_size / tc.forms
end


"""Compute ratio of distinct tokens to size of corpus.

$(SIGNATURES)
"""
function vocabulary_density(tc::TextCounts)
    tc.vocabulary_size / tc.corpus_size
end


"""Compute ratio of lexicon size to number of tokens parsed.

$(SIGNATURES)
"""
function lexical_density(tc::TextCounts)
    tc.lexicon_size / tc.parsed_tokens
end


"""Compute percentage of all tokens parsed.

$(SIGNATURES)
"""
function token_coverage(tc::TextCounts)
    tc.parsed_tokens / tc.corpus_size
end

"""Compute percentage unique tokens parsed.

$(SIGNATURES)
"""
function vocabulary_coverage(tc::TextCounts)
    tc.parsed_vocabulary / tc.vocabulary_size
end





"""Profile a citable corpus.

$(SIGNATURES)
"""
function profile(c::CitableTextCorpus, p::CitableParser;  data = nothing)
    analyses = parsecorpus(c, p; data = data)
    count_analyses(analyses) |> profile
end


"""Profile a citable doocument.

$(SIGNATURES)
"""
function profile(d::CitableDocument, p::CitableParser;  data = nothing)
    analyses = parsedocument(d, p; data = data)
    count_analyses(analyses)  |> profile
end

"""Profile a citable passage.

$(SIGNATURES)
"""
function profile(psg::CitablePassage, p::CitableParser;  data = nothing)
    analyses = parsepassage(psg, p; data = data)
    count_analyses(analyses)  |> profile
end