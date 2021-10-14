"""Computed profile for a Vector of `AnalyzedToken`s.
"""
struct TextProfile
    summary::AbstractString
    counts::TextCounts
    vocab_density
    token_coverage
    vocab_coverage
    lex_density
    form_density_corpus
    form_density_vocab
    form_density_lex
    m_ambiguity
    l_ambiguity
end

"""Compute profile from numbers in `TextCounts`.

$(SIGNATURES)
"""
function profile(tc::TextCounts, summary::AbstractString)
    TextProfile(
        summary,
        tc, 
        vocabulary_density(tc),
        token_coverage(tc),
        vocabulary_coverage(tc),
        lexical_density(tc),
        form_density_incorpus(tc),
        form_density_invocabulary(tc),
        form_density_inlexicon(tc),
        formal_ambiguity(tc),
        lexical_ambiguity(tc)
    )
end


"""Percentage of all tokens parsed.

$(SIGNATURES)
"""
function token_coverage(tp::TextProfile)
    tp.token_coverage
end

"""Ratio of lexically ambiguous tokens  to all parsed tokens.

$(SIGNATURES)
"""
function lexical_ambiguity(tp::TextProfile)
    tp.l_ambiguity
end

"""Ratio of distinct forms to all tokens parsed.

$(SIGNATURES)
"""
function formal_ambiguity(tp::TextProfile)
    tp.m_ambiguity
end

"""Ratio of lexicon to distinct forms.

$(SIGNATURES)
"""
function form_density_inlexicon(tp::TextProfile)
    tp.form_density_lex
end

"""Ratio of vocabulary items to distinct forms.

$(SIGNATURES)
"""
function form_density_invocabulary(tp::TextProfile)
    tp.form_density_vocab
end


"""Ratio of tokens to distinct forms.

$(SIGNATURES)
"""
function form_density_incorpus(tp::TextProfile)
    tp.form_density_corpus
end

"""Ratio of lexicon size to number of tokens parsed.

$(SIGNATURES)
"""
function lexical_density(tp::TextProfile)
    tp.lex_density
end

"""Ratio of distinct tokens to size of corpus.

$(SIGNATURES)
"""
function vocabulary_density(tp::TextProfile)
    tp.vocab_density
end

"""Percentage of unique tokens parsed.

$(SIGNATURES)
"""
function vocabulary_coverage(tp::TextProfile)
    tp.vocab_coverage
end


function summary(tp::TextProfile)
    tp.summary
end

# Access fields of a profile's TextCounts member.

function total_tokens(tp::TextProfile)
    tp.counts.corpus_size
end

function vocabulary(tp::TextProfile)
    tp.counts.vocabulary_size
end

function lexicon(tp::TextProfile)
    tp.counts.lexicon_size
end

function parsed_tokens(tp::TextProfile)
    tp.counts.parsed_tokens
end 

function parsed_vocabulary(tp::TextProfile)
    tp.counts.parsed_vocabulary
end 

function forms(tp::TextProfile)
    tp.counts.forms
end

function ambiguous(tp::TextProfile)
    tp.counts.ambiguous_tokens
end

function morphologically_ambiguous(tp::TextProfile)
    tp.counts.m_ambiguous
end

function lexically_ambiguous(tp::TextProfile)
    tp.counts.l_ambiguous
end
